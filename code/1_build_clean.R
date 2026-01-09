# Run this one only ####

rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source("R/00_config.R")
source("R/01_read_raw.R")
source("R/02_clean_transform.R")

build_one_wide <- function(sheet_index) {
  years <- initial_year:final_year
  out <- vector("list", length(years))
  
  for (i in seq_along(years)) {
    y <- years[i]
    tmp_read  <- read_excel_sheet(year = y, sheet_index = sheet_index)
    tmp_clean <- clean_transform(tmp_read)
    
    # tag variable code 
    tmp_clean$variavel <- variables_guide$nome_code[variables_guide$index == sheet_index]
    
    out[[i]] <- tmp_clean
  }
  
   do.call(rbind.fill, out)
}

# Build the four WIDE tables (one per variable/sheet)
pam_area_plantada_wide <- build_one_wide(1)
pam_area_colhida_wide  <- build_one_wide(2)
pam_qtd_produzida_wide <- build_one_wide(3)
pam_valor_prod_wide    <- build_one_wide(4)


key_cols <- c("cod_muni", "nom_muni", "uf", "ano", "variavel", "unidade")
pam_area_plantada_wide <- pam_area_plantada_wide[, c(key_cols, setdiff(colnames(pam_area_plantada_wide), key_cols))]
pam_area_colhida_wide <- pam_area_colhida_wide[, c(key_cols, setdiff(colnames(pam_area_colhida_wide), key_cols))]
pam_qtd_produzida_wide <- pam_qtd_produzida_wide[, c(key_cols, setdiff(colnames(pam_qtd_produzida_wide), key_cols))]
pam_valor_prod_wide <- pam_valor_prod_wide[, c(key_cols, setdiff(colnames(pam_valor_prod_wide), key_cols))]

# checking #####

stopifnot(!anyDuplicated(pam_area_plantada_wide[, c("cod_muni","ano")]))
stopifnot(!anyDuplicated(pam_area_colhida_wide[,  c("cod_muni","ano")]))
stopifnot(!anyDuplicated(pam_qtd_produzida_wide[, c("cod_muni","ano")]))
stopifnot(!anyDuplicated(pam_valor_prod_wide[,     c("cod_muni","ano")]))

table(pam_qtd_produzida_wide$unidade)
table(pam_valor_prod_wide$unidade)


# save (choose one)
saveRDS(pam_area_plantada_wide, file = "../data/clean/pam_area_plantada.rds")
saveRDS(pam_area_colhida_wide, file = "../data/clean/pam_area_colhida.rds")
saveRDS(pam_qtd_produzida_wide, file = "../data/clean/pam_qtd_produzida.rds")
saveRDS(pam_valor_prod_wide, file = "../data/clean/pam_valor_prod.rds")



