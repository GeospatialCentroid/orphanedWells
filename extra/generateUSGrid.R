###
# generate usa grid 
# carverd@colostate.edu
# 20220128
### 


# load packages -----------------------------------------------------------
pacman::p_load("readr", "terra")


# generate raster with known parameters -----------------------------------

## read in data
d1 <- read_csv("data/usGrid/US_chevron_fullstates.csv")
## set extent and resolution 
x <- rast(xmin=min(d1$longitude), xmax=max(d1$longitude), ymin=min(d1$latitude), ymax=max(d1$latitude))
res(x) <- 0.09009
## this is here for visualization olny
values(x) <- 1

# associate values from the csv to the raster object ----------------------

## convert to spatial object
sp1 <- vect(x = d1, geom = c("longitude", "latitude"),crs = crs(x))
## convert to raster
r2 <- rasterize(x = sp1, y = x, field ="GridID" )



# write out feature -------------------------------------------------------

terra::writeRaster(r2, filename = "data/usGrid/10_kmGrid.tif", overwrite=TRUE)
