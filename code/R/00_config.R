# load packages ####
library(readxl)


# raw files directory ####
raw_files_path <- "../data/raw/pam_all_years/"

# build intermediary folder structure ####
if(!dir.exists("../data/intermediary_objects")){
  dir.create("../data/intermediary_objects")
}

# set the years ####
initial_year <- 1974
final_year <- 2024

# check if we have original files for all these years ####
files_available <- list.files(raw_files_path)
unavailable_years <- setdiff(paste0("pam_", initial_year:final_year, ".xlsx"), files_available)
if(length(unavailable_years) > 0){
  stop(
  paste0(" NOT ALL YEARS ARE AVAILABLE \nCheck if ", 
  paste0(unavailable_years, collapse = ", "), " are present in the raw files folder"), call. = F
 
  
  
  )
  
}

# variables to be selected ####
# Since details of the variables may change,
# we will merge the beginning of the string only.

variables_guide <- data.frame(index = c(1:4),
  nome_sheet =  c("Área plantada",
                  "Área colhida",
                  "Quantidade produzida",
                  "Valor da produção"),
  nome_code = c("area_plantada",
                "area_colhida",
                "qtd_produzida",
                "valor_producao"),
  unidade_padrao = c(
    "hectares",
    "hectares",
    "toneladas",
    NA
  )
)


# calling unit conversion files ####

conversion_units <- read_excel("../config/pam_unit_conversions.xlsx")

standard_unit <- "toneladas" #this is the standard unit for production.
# products that are presented in alternative  units and cannot be directly
# adjusted will have their alternative unit added to the column name.


# PAM notes, according to SIDRA information:

# 1 - Os municípios sem informação para pelo menos um produto da lavoura não aparecem nas listas;	
# 2 - A partir do ano de 2001 as quantidades produzidas dos produtos abacate, banana, caqui, figo, goiaba, laranja, limão, maçã, mamão, manga, maracujá, marmelo, melancia, melão, pera, pêssego e tangerina passam a ser expressas em toneladas. Nos anos anteriores eram expressas em mil frutos, com exceção da banana, que era expressa em mil cachos. O rendimento médio passa a ser expresso em Kg/ha. Nos anos anteriores era expresso em frutos/ha, com exceção da banana, que era expressa em cachos/ha.	
# 3 - Veja em https://sidra.ibge.gov.br/content/documentos/pam/AlteracoesUnidadesMedidaFrutas.pdf um documento com as alterações de unidades de medida das frutíferas ocorridas em 2001 e a tabela de conversão fruto x quilograma.	
# 4 - Até 2001, café (em coco), a partir de 2002, café (beneficiado ou em grão).	
# 5 - Os produtos girassol e triticale só apresentam informação a partir de 2005.	
# 6 - As quantidades produzidas de abacaxi e de coco-da-baía são expressas em mil frutos e o rendimento médio em frutos/ha.	
# 7 - Valores para a categoria Total indisponíveis para as variáveis Quantidade produzida e Rendimento médio, pois as unidades de medida diferem para determinados produtos.	
# 8 - Subentende a possibilidade de cultivos sucessivos ou simultâneos (simples, associados e/ou intercalados) no mesmo ano e no mesmo local, podendo, por isto, a área informada da cultura exceder a área geográfica do município.	
# "9 - As culturas de abacaxi, cana-de-açúcar, mamona e mandioca são consideradas culturas temporárias de longa duração. Elas costumam ter ciclo vegetativo que ultrapassa 12 meses e, por isso, as informações são computadas nas colheitas realizadas dentro de cada ano civil (12 meses).
# Nestas culturas a área plantada refere-se a área destinada à colheita no ano."	
# "11 - A variável Área plantada ou destinada à colheita só passou a ser informada a partir de 1988.
# 12 - Valor da produção: Variável derivada calculada pela média ponderada das informações de quantidade e preço médio corrente pago ao produtor, de acordo com os períodos de colheita e comercialização de cada produto. As despesas de frete, taxas e impostos não são incluídas no preço.
# 
# 13 - Os dados do último ano divulgado são RESULTADOS PRELIMINARES e podem sofrer alterações até a próxima divulgação."	


# line identification names ####
line_identification <- c("cod_muni", "nom_muni", "uf", "ano")
