base_dir <- "/mainfs/HNSCgenomics/data_for_Hayden/reordered_exomes_H/IntegrationDir/"


file_list <- list.files(path = base_dir,
                        pattern = "^results\\.remapped\\.t1\\.txt$",
                        recursive = TRUE,
                        full.names = TRUE)

cat("Number of files found:", length(file_list), "\n")
cat("Files:\n")
cat(paste(file_list, collapse = "\n"), "\n")
q()