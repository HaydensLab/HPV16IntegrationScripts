library(virusPlot)
library(data.table)
library(ggplot2)

#base_dir <- "/mainfs/HNSCgenomics/data_for_Hayden/reordered_exomes_H/IntegrationDir/"
base_dir <- "C:/Users/hayde/Documents/MASTERS DEGREE DISS"

file_list <- list.files(path = base_dir,
                        pattern = "^results\\.remapped\\.t1\\.txt$",
                        recursive = TRUE,
                        full.names = TRUE)

cat("Number of files found:", length(file_list), "\n")
cat("Files:\n")
cat(paste(file_list, collapse = "\n"), "\n")


#preparing list of dataframes
all_data <- list()
all_data_directional <- list()
#for loop iterating over the list of files identified and creating a dataframe that is then saved for each
for (i in file_list)
{
if (file.info(i)$size == 0){
  message("Skipping empty file: ", i)
  next
}
Integration <- read.table(i,sep = " ",fill = TRUE, header=FALSE)
Integration <- Integration[, -1]
Integration <- Integration[, 1:6]

sample_name <- sub("_Integration$", "", basename(dirname(i)))

chr_list <-sub(":.*", "", Integration[, 1])
host_loc_list <- abs(as.numeric(sub(".*:", "", Integration[, 1])))
hpv_loc_list <- abs(as.numeric(sub(".*:", "", Integration[, 2])))
reads_list <- abs(as.numeric(sub(".*=", "", Integration[, 3])))
sample_list <- rep(sample_name, length.out = nrow(Integration))

#Integrationdataframe
insert_info <- data.frame(
  chr      = chr_list,
  host_loc = host_loc_list,
  hpv_loc  = hpv_loc_list,
  reads    = reads_list,
  sample   = sample_list,
  stringsAsFactors = FALSE
)
  ###directionality
  chr_list_directional <- sub(":.*", "", Integration[, 1])
  host_loc_list_directional <- as.numeric(sub(".*:", "", Integration[, 1]))
  hpv_loc_list_directional <- as.numeric(sub(".*:", "", Integration[, 2]))
  reads_list_directional <- as.numeric(sub(".*=", "", Integration[, 3]))
  sample_list_directional <- rep(sample_name, length.out = nrow(Integration))
  
  #Integrationdataframe
  insert_info_directional <- data.frame(
    chr      = chr_list_directional,
    host_loc = host_loc_list_directional,
    hpv_loc  = hpv_loc_list_directional,
    reads    = reads_list_directional,
    sample   = sample_list_directional,
    stringsAsFactors = FALSE
  
)
#store information into dataframe list
  all_data[[length(all_data) + 1]] <- insert_info
  all_data_directional[[length(all_data_directional) + 1]] <- insert_info_directional
}

Pan_Input_dataframe <- do.call(rbind, all_data)
Pan_Input_dataframe_directional <- do.call(rbind, all_data_directional)
print(Pan_Input_dataframe) # output to Rout the pan dataframe
print(Pan_Input_dataframe_directional)





########virusplot package section##########
genome <- get_virus_genom(accession_number = "NC_001526.4",
                          email = "hl8n21@soton.ac.uk")
print(head(genome))

virus_info_NC_001526.4 <- data.table(gene = c("E1", "E1^E4", "E2", "E5", "L2", "L1", "E6", "E7"),
                                     start = as.numeric(c("1", "1", "1892", "2986", "3373", "4775", "7125", "7604")),
                                     end = as.numeric(c("1950", "2756", "2989", "3237", "4794", "6292", "7601", "7900")))

Genomic_Integration <- strudel_plot(virus_info = virus_info_NC_001526.4, Pan_Input_dataframe, 
                                    hot_gene = 3, size_gene = 5, size_label = 5, text_repel = TRUE)





png("Pan_Sample_Genomic_Integration.png", width = 5000, height = 2000, res = 300)
Genomic_Integration + 
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1.5)  # rotate 45°
  )
print(Genomic_Integration)
dev.off()

hot_gene <- get_hot_gene(virus_info = virus_info_NC_001526.4, Pan_Input_dataframe)
insert_plot <- hot_gene_plot(hot_gene)
png("Pan_Sample_Genomic_Integration_levels.png", width = 3000, height = 2000, res = 300)
print(insert_plot[[2]])
dev.off()

Pan_Input_dataframe <- Pan_Input_dataframe[order(-Pan_Input_dataframe[, 4]), ]
write.table(Pan_Input_dataframe, file = "Pan_Sample_Integration_list.txt", sep = "\t", row.names = FALSE, quote = FALSE)
Pan_Input_dataframe_directional <- Pan_Input_dataframe_directional[order(-Pan_Input_dataframe_directional[, 4]), ]
write.table(Pan_Input_dataframe_directional, file = "Pan_Sample_Integration_list_directional.txt", sep = "\t", row.names = FALSE, quote = FALSE)
#run_virusPlot() #just incase to run webserver (WHILST R IS ACTIVE) - to do so remove dev.off from lines above.
q()