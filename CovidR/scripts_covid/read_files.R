read_files <- function(files) {
  unlist(lapply(files, readLines))
}