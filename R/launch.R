#' @export
RosyPackages <- c(
  "Rosyverse",
  "RosyDev",
  "RosyUtils",
  # "RosyDB",
  "RosyApp",
  "RosyREDCap",
  "REDCapSync",
  "RosyRx",
  "rosymap"
)
#' @title load_all
#' @export
load_all <-function(){
  for(p in RosyPackages){
    library(p,character.only = TRUE)
  }
}
#' @title update_all
#' @export
update_all <-function(restart_after = TRUE){
  was_updated_at_all <- FALSE
  for(p in RosyPackages){
    version_before <- tryCatch(utils::packageVersion(p), error = function(e) NA)
    repo <- "brandonerose"
    if(p%in%c("REDCapSync","RosyREDCap"))repo <- "thecodingdocs"
    remotes::install_github(paste0(repo,"/",p),upgrade = "never")
    version_after <- tryCatch(utils::packageVersion(p), error = function(e) NA)
    if(!is.na(version_before)){
      was_updated <- version_before != version_after
    }else{
      was_updated <- TRUE
    }
    if(was_updated) was_updated_at_all <- TRUE
  }
  if(was_updated_at_all&&restart_after) .rs.restartR()
}
#' @title remove_all
#' @export
remove_all <- function(){
  for(x in c(RosyPackages)){
    utils::remove.packages(x)
  }
  message("All Rosy packages removed!")
}
