#' getGPP 
#' @description : extract GPP values from raster to spatial polygon. Returns a dataframe with all values and reference ID 
#' @param gpp : multiband raster of Net Primary Productivity 
#' @param gridArea : Reference grid as spatial polygon containing reference ID  
#'
#' @return dataframe of reference Id and GPP values 
getGPP <- function(gpp, gridArea){
  
  # construct dataframe to hold outputs from the extraction  
  df <- data.frame(matrix(nrow = nrow(gridArea), ncol = 1 + length(names(gpp))))
  names(df) <- c("Id", names(gpp))
  df$Id <- gridArea$Id
  
  # run extraction for each cell and append data
  for(i in seq_along(df$Id)){
    temp <- terra::extract(x = gpp, y = gridArea[i,]) %>%
      dplyr::slice(1)%>%
      dplyr::select(-1)%>%
      unlist(use.names = FALSE)
    # attach data
    df[i, 2:ncol(df)] <- temp
    # counter for progress
    if(i %% 10 == 0){
      print(paste0(i ," out of ", nrow(df)))
    }
  }
  return(df)
}