#' GetAUS_LC
#'
#' @param landcover 
#' @param gridArea 
#'
#' @description 
#' 
#' 
#' @return
#' @export
#'
#' @examples
#' 
#' 


getAUS_LC <- function(landcover, gridArea){
  
  gridArea <- gridArea %>%
    terra::project(landcover)
  
  # just looking at the plot legend for list of all values
  values <- c(1:32,99)
  
  # construct dataframe to hold all records 
  df <- data.frame(matrix(nrow = nrow(gridArea), ncol = 2+ length(values)))
  names(df) <- c("Id", as.character(values), "total_land_cells")
  
  #iterate over each area and assign values 
  
  for(i in seq_along(gridArea$OZgrids)){
    # select feature
    t1 <- gridArea[i]
    # assgin Id 
    df$Id[i] <- t1$OZgrids
    # crop and mask image 
    r2 <- landcover %>% terra::crop(t1)%>%terra::mask(t1)
    # determine values 
    vals <- values(r2)
    # drop na values 
    ### historic datas uses 128 in stead of NA so I'm reassigning to remove
    vals[vals == 128] <- NA
    vals <- vals[!is.na(vals)]
    uniqueVals <- sort(unique(vals))
    total <- length(vals)
    df[i, "total_land_cells"] <- total
    for(j in seq_along(values)){
      code <- as.numeric(values[j])
      if(code %in% uniqueVals){
        index <- code
        val2 <- vals[vals == index]
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