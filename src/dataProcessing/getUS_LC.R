#' getUS_LC
#' @description : aggregate percent land cover for each polygon using 2019 NLCD 
#' @param landcover : 2019 NLCD 
#' @param gridArea : spatial polygon with reference Id 
#'
#' @return : a dataframe with reference Id and percent area for all NLCD classes. 
getUS_LC <- function(landcover, gridArea){
  #grap legend for nlcd 
  l1 <- FedData::pal_nlcd()
  
  gridArea <- gridArea %>%
    terra::project(landcover)
  
  # construct dataframe to hold all records 
  df <- data.frame(matrix(nrow = nrow(gridArea), ncol = 1+ length(l1$description)))
  names(df) <- c("Id", l1$code)
  
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
    uniqueVals <- sort(unique(vals))
    total <- length(vals)
    for(j in seq_along(l1$code)){
      code <- as.numeric(l1$code[j])
      if(code %in% uniqueVals){
        index <- code
        val2 <- vals[vals == index, ]
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




