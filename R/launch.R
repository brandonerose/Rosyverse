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
#' @title update_all
#' @export
update_all <- function(restart_after = TRUE) {
  was_updated_at_all <- FALSE
  for (p in RosyPackages) {
    version_before <- tryCatch(
      utils::packageVersion(p),
      error = function(e)
        NA
    )
    was_updated <- TRUE
    if (p == "REDCapSync") {
      install.packages(p)
    } else {
      repo <- ifelse(p == "RosyREDCap", "thecodingdocs", "brandonerose")
      remotes::install_github(paste0(repo, "/", p), upgrade = "always")
    }
    version_after <- tryCatch(
      utils::packageVersion(p),
      error = function(e)
        NA
    )
    if (!is.na(version_before)) {
      was_updated <- version_before != version_after
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
  for (x in c(RosyPackages)) {
    utils::remove.packages(x)
  }
  message("All Rosy packages removed!")
}
