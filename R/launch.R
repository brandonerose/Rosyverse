#' @export
RosyPackages <- c("Rosyverse","RosyDev","RosyUtils","RosyDB","RosyApp","RosyREDCap")
#' @title load_all
#' @export
load_all <-function(){
  for(p in RosyPackages){
    library(p,character.only = T)
  }
}
#' @title update_all
#' @export
update_all <-function(restart_after = T){
  was_updated_at_all <- F
  for(p in RosyPackages){
    version_before <- tryCatch(utils::packageVersion(p), error = function(e) NA)
    remotes::install_github(paste0("brandonerose/",p),upgrade = "never")
    version_after <- tryCatch(utils::packageVersion(p), error = function(e) NA)
    if(!is.na(version_before)){
      was_updated <- version_before != version_after
    }else{
      was_updated <- T
    }
    if(was_updated) was_updated_at_all <- T
  }
  if(was_updated_at_all&&restart_after) .rs.restartR()
}
#' @title check_Rosyverse_conflicts
#' @export
check_Rosyverse_conflicts<-function(others=NULL){
  DF <- RosyDev::check_namespace_conflicts(c(RosyPackages,others))
  if(is.null(DF))return()
  return(DF)
}
all_package_deps <- function(){
  RosyApp::`%>%`
  RosyDev::`%>%`
  RosyDB::`%>%`
  RosyUtils::`%>%`
  RosyREDCap::`%>%`
  return(NULL)
}
#' @title remove_all
#' @export
remove_all <- function(){
  for(x in c(RosyPackages)){
    utils::remove.packages(x)
  }
  RosyUtils::bullet_in_console("All Rosy packages removed!",bullet_type = "v")
}
