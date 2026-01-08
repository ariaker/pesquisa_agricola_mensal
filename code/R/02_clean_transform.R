# From the output of 01_read_raw.R, the function here cleans and transforms
# the dataset, adjusting units, returning prepared dataset.

clean_transform <- function(read_raw_list){
  
  # preparing the UF ####
  uf <- NA
  dataset <- cbind(read_raw_list$data[,c(1:2)], uf, read_raw_list$data[,c(3:ncol(read_raw_list$data))])
  dataset$uf <- gsub(".*\\(([A-Z]{2})\\)$", "\\1", dataset$nom_muni)
  dataset$nom_muni <- gsub(" \\([A-Z]{2}\\)", "", dataset$nom_muni)
  
  # substituting the "..." #### 
  dataset[dataset == "..."] <- NA
  
  # substituting the "-" ####
  dataset[dataset == "-"] <- 0
  
  # making relevant columns numeric ####
  dataset[,!(colnames(dataset) %in% c("nom_muni", "uf"))] <- apply(dataset[,!(colnames(dataset) %in% c("nom_muni", "uf"))], 2, as.numeric)
  
  # fixing production columns, if necessary ####
  if(read_raw_list$sheet_index == 3){ # we enter here if it is qtd produzida
    
    # 2 tasks: 
    #         adjust those that had their units change from 2000 to 2001
    #         make sure that the discontinued ones have different names
    temp_conversion_units <- conversion_units[conversion_units$ano_ini <= read_raw_list$year,]
    temp_conversion_units <- temp_conversion_units[temp_conversion_units$ano_fim >= read_raw_list$year,]
    
    # select those that need transformation 
    temp_unit_change <- temp_conversion_units[temp_conversion_units$unit_from != temp_conversion_units$unit_to,]
    
    for(index_prod in 1:nrow(temp_unit_change)){
      
      prod <- temp_unit_change$produto[index_prod]
      
      dataset[,colnames(dataset) == prod] <- dataset[,colnames(dataset) == prod] * temp_unit_change$factor_to_multiply[index_prod]
      
    } # end of loop to fix units
    
    
    # fixing series that break 
    
    temp_series_break <- temp_conversion_units[temp_conversion_units$series_break == "T",]
    
    for(index_prod in 1:nrow(temp_series_break)){
      
      prod <- temp_series_break$produto[index_prod]
      
      colnames(dataset)[grepl(prod, colnames(dataset))] <- paste0( colnames(dataset)[grepl(prod, colnames(dataset))], "_", temp_series_break$unit_to[index_prod])
      
      
    } # end of fixing series that break 
    
    
    # fixing series that have alternative unit 
    
    
    
    
    
    
  } # end of production conditional if
  
  
  
  
}