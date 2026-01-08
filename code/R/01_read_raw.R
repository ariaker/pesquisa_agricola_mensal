# This program contains the function to read a file, from a year, for a 
# for a defined spreadsheet.

read_excel_sheet <- function(year, sheet_name){
  
  path_file <- paste0(raw_files_path, "pam_", year, ".xlsx")
  sheets <- excel_sheets(path_file)
  
  index_sheet <- grepl(sheet_name, sheets) |> which()
    
  pam_file <-   read_excel(path_file, 
                           sheet = index_sheet, 
                           skip = 3)
  colnames(pam_file)[1:3] <- c("cod_muni", "nom_muni", "ano")
  
  # Remove notes line
  pam_file <- pam_file[!grepl("Fonte: IBGE", pam_file$cod_muni),]
  
  # collecting the variable unit 
  heading <-  read_excel(path_file, 
                                       sheet = index_sheet, range = "A2:A2"
                                        ) |> names()
  
  if(grepl(pattern = "\\(", heading)){
  unit <- sub(".*\\((.+)\\)$","\\1", heading) |> tolower()
  } else {unit <- ""}
  
  # next step: clean variable names
  
  colnames(pam_file) <- colnames(pam_file) |> tolower()
  colnames(pam_file) <- gsub("\\(.+\\)", "", colnames(pam_file))
  colnames(pam_file) <- gsub(" $|\\*", "", colnames(pam_file))
  colnames(pam_file) <- gsub("  ", " ", colnames(pam_file))
  colnames(pam_file) <- iconv(colnames(pam_file), from = "UTF-8", to = "ASCII//TRANSLIT")
  colnames(pam_file) <- gsub(" |-", "_", colnames(pam_file))
  
  return(list(data = pam_file, unit = unit, sheet_name = sheet_name, year = year))
}

