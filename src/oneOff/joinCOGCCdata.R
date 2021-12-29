library(dplyr)
library(sf)
library(tigris)
library(tmap)

# read in data ------------------------------------------------------------
## orphened wells 
ow <- read.csv("data/projectList.csv")
## state data
stateW <- read.csv("data/stateWells.csv")
## fed data  
fedW <- read.csv("data/federalWells.csv")
##comibne all wells 
allWells <- bind_rows(stateW, fedW)


# attach county data to well locations ------------------------------------
county <- tigris::counties(state = "CO")
c1 <- county %>%
  dplyr::select("NAME")

# generate spatail data from well sites 
w2 <- sf::st_as_sf(allWells, coords = c("Longitude", "Latitude"),remove=FALSE)%>%
  sf::st_set_crs(value = 4326)%>%
  sf::st_transform(crs = sf::st_crs(c1))%>%
  dplyr::select(-description)
w2 <- sf::st_intersection(w2,c1)



# function to testing connections -----------------------------------------
for(i in seq_along(w2$Name)){
  test <- w2[i, ]
  # filter on county 
  d1 <- ow[grepl(pattern = test$NAME, x = ow$County,ignore.case = TRUE),]
  # filter on project name 
  d2 <- dplyr::left_join(x = test, y = d1,
                         by = c("Project_Name"= "Project.Name"))
  # condition for exact match
  if(nrow(d2)==1){
    if(i == 1){
      matched <- d2
    }else{
      matched <- dplyr::bind_rows(matched, d2)
    }
  }else{
    print(i)
  }
}

write.csv(x = matched%>%st_drop_geometry(),
          file = "outputs/matchedWells/orphanedWells_LatLon.csv")
st_write(obj = matched,"outputs/matchedWells/orphanedWells.shp")

