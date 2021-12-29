library(sf)
library(dplyr)
library(tmap)
library(raster)
library(tmap)
library(terra)
tmap::tmap_mode("view")

d1 <- st_read("data/usGrid/US10km_reduced_grids.shp")%>%
  as("Spatial")


USgridded <- raster(crs = crs(d1),ext = extent(d1), value =1)

r <- rasterize(d1, USgridded, value = "Id")

tm_shape(r) +
  tm_raster() +
  tm_shape(d1a)+
  tm_polygons()



## gpp data 
r2 <- rast("data/earthEngineOutputs/gpp.tif")
## shp 
spat2 <- vect("data/usGrid/US10km_reduced_grids.shp")%>%
  terra::project(r2)




for(i in 1:nlyr(r2)){
  
  rast1 <- r2[[i]]
  
  vals <- terra::extract(x = rast1, y = spat2[1:100,])
  
  
  vals <- terra::extract(x=r2, y = spat2[30, ])
}

