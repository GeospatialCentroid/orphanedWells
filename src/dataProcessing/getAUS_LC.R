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

landcover <- ausLC 
gridArea <- auGrid

getAUS_LC <- function(landcover, gridArea){
  
  gridArea <- gridArea %>%
    terra::project(landcover)
  
  # just looking at the plot legend for list of all values
  values <- c(1:32,99)
  
  # construct dataframe to hold all records 
  df <- data.frame(matrix(nrow = nrow(gridArea), ncol = 1+ length(values)))
  names(df) <- c("Id", as.character(values))
  
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
    # Nan features causing some issues 
    vals[is.nan(vals)] <- 9999
    vals[is.na(vals)] <- 9991
    total <- length(vals)
    for(j in seq_along(values)){
      code <- as.numeric(values[j])
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