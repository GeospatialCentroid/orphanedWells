### 
# primary workflow for all dataprocessing efforts 
# carverd@colostate.edu
# 20211223
### 

# install.packages("pacman")
pacman::p_load(dplyr, readr, sf, terra)


# source scripts ----------------------------------------------------------
for(feature in list.files(path = "src/dataProcessing" ,full.names = TRUE)){
  source(feature)
}

# input datasets ----------------------------------------------------------
## usa
usGPP <- rast("data/earthEngineOutputs/gppUSA.tif")
usGrid <- rast("data/usGrid/10_kmGrid.tif")%>%
  terra::project(usGPP)%>%
  terra::as.polygons()
names(usGrid) <- "Id"

usLandCover <- rast("data/usLandCover/nlcd_2019_land_cover_l48_20210604.img") # this local file does not work.
usLandCover <- rast("L:/Projects_active/EnviroScreen/data/NLCD/Land Cover/nlcd_2019_land_cover_l48_20210604.img")

## aus 
auGPP <- rast("data/earthEngineOutputs/gppAus.tif")
auGrid <- rast("data/ausGrid/OZgrids.tif")%>%
  terra::project(auGPP)%>%
  terra::as.polygons()
# names(gridArea) <- "Id"
ausLC_current <- terra::rast("data/ausLandCover/ausLC.tif")  
ausLc_historic <- terra::rast("data/ausLandCover/ausLC_1750.tif")



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
## current 
ausLC1 <- getAUS_LC(landcover = ausLC_current, gridArea = auGrid)
readr::write_csv(ausLC1, file= paste0("outputs/ausLC_current",Sys.Date(),".csv"))
##historic 
auslc2 <- getAUS_LC(landcover = ausLc_historic, gridArea = auGrid)
readr::write_csv(auslc2 , file= paste0("outputs/ausLC_historic",Sys.Date(),".csv"))



