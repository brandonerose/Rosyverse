#' @export
RosyPackages <- c(
  "Rosyverse",
  "RosyDev",
  "RosyFinance",
  "RosyUtils",
  # "RosyDB",
  "RosyApp",
  "RosyREDCap",
  "REDCapSync",
  "RosyRx",
  "rosymap"
)
#' @title load_Rosyverse
#' @export
load_Rosyverse <-function(){
  invisible(lapply(RosyPackages, library, character.only = TRUE))
}
#' @title update_all
#' @export
update_all <- function(restart_after = TRUE) {
  was_updated_at_all <- FALSE
  new_versions <- old.packages()
  for (p in RosyPackages) {
    version_before <- tryCatch(
      utils::packageVersion(p),
      error = function(e)
        NA
    )
    was_updated <- FALSE
    if (p == "REDCapSync") {
      if (p %in% new_versions[, "Package"]) {
        install.packages(p)
        was_updated <- TRUE
      }
    } else {
      repo <- ifelse(p == "RosyREDCap", "thecodingdocs", "brandonerose")
      remotes::install_github(paste0(repo, "/", p), upgrade = "always")
      version_after <- tryCatch(
        utils::packageVersion(p),
        error = function(e)
          NA
      )
      if (is.na(version_before)) {
        was_updated <- TRUE
      } else{
        was_updated <- version_before != version_after
      }
    }
    if (was_updated)
      was_updated_at_all <- TRUE
  }
  if (was_updated_at_all && restart_after) {
    .rs.restartR()
  }
  invisible()
}
#' @title remove_all
#' @export
remove_all <- function() {
  utils::remove.packages(RosyPackages)
  message("All Rosy packages removed!")
}
