### 
# primary workflow for all dataprocessing efforts 
# carverd@colostate.edu
# 20211223
### 

# install.packages("pacman")
pacman::p_load(dplyr, readr, sf, terra, FedData)


# source scripts ----------------------------------------------------------
for(i in list.files(path = "src/dataProcessing" ,full.names = TRUE)){
  source(i)
}

# input datasets ----------------------------------------------------------
## usa
usGPP <- rast("data/earthEngineOutputs/gppUSA.tif")
usGrid <- vect("data/usGrid/US10km_reduced_grids.shp")
usLandCover <- rast("data/usLandCover/nlcd_2019_land_cover_l48_20210604.img")

## aus 
auGPP <- rast("data/earthEngineOutputs/gppAus.tif")
auGrid <- rast("data/ausGrid/OZgrids.tif")%>%
  terra::project(auGPP)%>%
  terra::as.polygons()
names(auGrid) <- "Id"


# USA GPP -----------------------------------------------------------------
usaGPP <- getGPP(gpp = usGPP, gridArea = usGrid)
# write data 
readr::write_csv(x = usaGPP, file = paste0("outputs/usaGPP_",Sys.Date(),".csv"))
                 

# AUS GPP -----------------------------------------------------------------
## datasets
# getGPP
ausGPP <- getGPP(gpp = r1a ,gridArea = g1a)
# write data 
readr::write_csv(x = ausGPP, file = paste0("outputs/ausGPP_",Sys.Date(),".csv"))


# USA land Cover ---------------------------------------------------------
usaLC <- getUS_LC(landcover = usLandCover, gridArea = usGrid)
readr::write_csv(usaLC, file= paste0("outputs/usaLC",Sys.Date(),".csv"))



# AUS land cover ----------------------------------------------------------



