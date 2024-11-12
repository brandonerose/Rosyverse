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
update_all <-function(restart_after = F){
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
  DF <- DF[which(!DF$function_name%in%c(
    "%>%",
    "pkg_date",
    "pkg_version",
    "pkg_name",
    ".__NAMESPACE__.",
    ".__S3MethodsTable__.",
    ".packageName"
  )
  ),]
  return(DF)
}
