rename_rev <- function(.folder) {
  file_to_rename <- c("TestResultQC_v3 REV.txt",
                      "Sample_v3 REV.txt")
  
  for (i in file_to_rename) {
    .file <- file.path(.folder, i)
    # Check that the file exists.
    # If TRUE, rename the file.
    if (file.exists(.file)) {
      file.rename(from = .file,
                  to = gsub(" REV.txt", ".txt", .file))
    }
  }
}

.path  <- input_path
.folder <- list.files(path = input_path)[1]
import_als <- function(.path, .folder) {
  folder_path <- file.path(.path,
                           .folder)
  
  rename_rev(.folder = folder_path)
  
  result_df <- read_als_results(.folder = folder_path)
  sample_df <- read_als_samples(.folder = folder_path)
  
  final_df <- dplyr::full_join(result_df, sample_df, by = "X.sys_sample_code") %>% 
    dplyr::rename(sys_sample_code = "X.sys_sample_code")

  return(final_df)
}

read_als_results <- function(.folder) {
  read.table(
    text = gsub("\t", ",", readLines(
      file.path(.folder, "TestResultQC_v3.txt")
    )),
    sep = ",",
    fill = TRUE,
    header = TRUE,
    stringsAsFactors = FALSE,
    colClasses = c(fraction = "character",
                   qc_rpd = "character")
  )
}

read_als_samples <- function(.folder) {
  read.table(
    text = gsub("\t", ",", readLines(file.path(
      .folder, "Sample_v3.txt"))),
    sep = ",",
    fill = TRUE,
    header = TRUE,
    stringsAsFactors = FALSE,
    colClasses = c(sampler = "character")
  )
}