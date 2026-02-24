base_dir <- ""


file_list <- list.files(path = base_dir,
                        pattern = "^results\\.remapped\\.t1\\.txt$",
                        recursive = TRUE,
                        full.names = TRUE)

cat("Number of files found:", length(file_list), "\n")
cat("Files:\n")
cat(paste(file_list, collapse = "\n"), "\n")

q()
