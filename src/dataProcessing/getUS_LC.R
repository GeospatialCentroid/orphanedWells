#' getUS_LC
#' @description : aggregate percent land cover for each polygon using 2019 NLCD 
#' @param landcover : 2019 NLCD 
#' @param gridArea : spatial polygon with reference Id 
#'
#' @return : a dataframe with reference Id and percent area for all NLCD classes. 
getUS_LC <- function(landcover, gridArea){
  #grab legend for nlcd 
  # https://www.mrlc.gov/data/legends/national-land-cover-database-2019-nlcd2019-legend
  l1 <- c(11:12,21:24,31,41:43,51:52,71:74,81:82,90,95)
  
  gridArea <- gridArea %>%
    terra::project(landcover)
  
  # construct dataframe to hold all records 
  df <- data.frame(matrix(nrow = nrow(gridArea), ncol = 2 + length(l1)))
  names(df) <- c("Id", l1, "total")
  
  #iterate over each area and assign values 

  for(i in seq_along(gridArea$Id)){
    # select feature
    t1 <- gridArea[i]
    # assgin Id 
    df$Id[i] <- t1$Id
    # crop and mask image 
    r2 <- landcover %>% terra::crop(t1)%>%terra::mask(t1)
    # determine values 
    vals <- values(r2)
    #drop NA and 0 
    vals[vals == 0] <- NA
    vals <- vals[!is.na(vals)]
    # total number of land based cells 
    total <- length(vals)
    df[i,"total"] <- total
    # unique land cover class in area 
    uniqueVals <- sort(unique(vals))
    for(j in seq_along(l1)){
      code <- as.numeric(l1[j])
      # test if the specific land cover class is present in subset area
      if(code %in% uniqueVals){
        index <- code
        val2 <- vals[vals == index ]
        sum1 <- length(val2)
        percentCover <- (sum1/total)*100
        df[i,as.character(index)] <- percentCover
      }
    }
    # counter for progress
    if(i %% 10 == 0){
      print(paste0(i ," out of ", nrow(df)))
    }
  }
  return(df)
}




