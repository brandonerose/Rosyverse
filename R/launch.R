RosyPackages <- c("Rosyverse","RosyDev","RosyUtils","RosyDB","RosyREDCap")
#' @title load_all
#' @export
load_all <-function(){
  for(p in RosyPackages){
    library(p,character.only = T)
  }
}
#' @title update_all
#' @export
update_all <-function(){
  was_updated_at_all <- F
  for(p in RosyPackages){
    version_before <- tryCatch(utils::packageVersion(p), error = function(e) NA)
    remotes::install_github(paste0("brandonerose/",p))
    version_after <- tryCatch(utils::packageVersion(p), error = function(e) NA)
    if(!is.na(version_before)){
      was_updated <- version_before != version_after
    }else{
      was_updated <- T
    }
    if(was_updated) was_updated_at_all <- T
  }
  if(was_updated_at_all) .rs.restartR()
}
