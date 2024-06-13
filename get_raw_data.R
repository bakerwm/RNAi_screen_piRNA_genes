

# Date: 2024-06-13
# Author: WM
# Version: 0.2

## RNAi screen
# setwd("~/wm_work/RNAi_screen_fruitfly/")
# setwd("D:/坚果云sync/我的坚果�?/工作目录/20191123-RNAi-screen/RNAi_screen_fruitfly/")

library(readr, quietly = T)
library(readxl, quietly = T)
library(tidyr, quietly = T)
library(dplyr, quietly = T)
library(tibble, quietly = T)

#------------------------------------------------------------------------------#
# summary (gene_list)
# 1. Greg_lab_Ben:        74, 216, 137, 377
# 2. Julius_lab_HHandler, 49, 80, 144
# 3. Greg_lab_Muerdter,   87, 52, 149
#------------------------------------------------------------------------------#

## Reference
# 1.	Czech, B., Preall, J. B., McGinn, J. & Hannon, G. J. A Transcriptome-wide RNAi Screen in the Drosophila Ovary Reveals Factors of the Germline piRNA Pathway. Mol. Cell 50, 749�?761 (2013).
# 2.	Handler, D. et al. The Genetic Makeup of the Drosophila piRNA Pathway. Mol. Cell 50, 762�?777 (2013).
# 3.	Muerdter, F. et al. A Genome-wide RNAi Screen Draws a Genetic Framework for Transposon Control and Primary piRNA Biogenesis in Drosophila. Mol. Cell 50, 736�?748 (2013).

## Preparing dirs
data_dirs <- file.path(
  "data", c("raw_list", "fixed_list")
)
tmp <- lapply(data_dirs, dir.create, recursive = T, showWarnings = F, mode = "755")

#------------------------------------------------------------------------------#
# 1. Greg lab, Ben 2013
#------------------------------------------------------------------------------#
#
# Benjamin Czech, 2013 (Greg lab)
# table S1: https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002888-mmc2.xlsx
# 
# Table S1. Raw Data for Primary Screen, Related to Figure 2. Shown are 
# transformant IDs (of VDRC stock center; TID), library (Lib), viability of fly
# stock, and chromosome insertion (Chr) of the dsRNA for all 8,171 RNAi lines 
# used. Gene IDs and synonyms are shown along with raw Z scores for HeTA, TAHRE,
# blood, and burdock.
#
# derepression threshold, Z-score
# genes; Z-score
# 74    -2.0
# 216   -1.5
# 137   -2.0 in at least two TE
# 377   -2.0 in at least one TE
fileURL <- "https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002888-mmc2.xlsx"
fileTableS1  <- "data/raw_list/1.0.Greg_lab_Ben_2013.TableS1.xlsx"
# download.file(fileURL, fileTableS1, method = "curl")
#
# including NA values (n.d.)
# 8171 records, 11 columns
df1 <- readxl::read_xlsx(fileTableS1, na = "n.d.") %>%
  dplyr::mutate(across(all_of(c("HeTA", "TAHRE", "blood", "burdock")), as.numeric))
print(dim(df1))
# mean values
df1 <- df1 %>% 
  dplyr::mutate(mean_col = rowMeans(dplyr::select(., HeTA:burdock), na.rm = TRUE)) %>%
  dplyr::arrange(mean_col)
# fix n.a. values
df1[is.na(df1)] <- 0
df1$status <- rowSums(dplyr::select(df1, HeTA:burdock) <= -2.0)
#-------------------------#
# threshold: -2.0, -1.5
#-------------------------#
## 1. mean value <= -2.0 (n=74)
## 2. mean value <= -1.5 (n=216)
## 3. at least in two TEs, <= -2.0 (n=137)
## 4. at least in one TE,  <= -2.0 (n=377)
df1 <- df1 %>%
  dplyr::mutate(
    tag1 = as.numeric(mean_col <= -2),
    tag2 = as.numeric(mean_col <= -1.5),
    tag3 = as.numeric(status   >= 2),
    tag4 = as.numeric(status   >= 1)
  )
colSums(dplyr::select(df1, contains("tag")))
# df1 <- df1[df1$status > 0, ]
#-------------------------#
# save each table to files
#-------------------------#
## tag1: mean_value <= -2.0 (n=74)
f1a  <- "data/raw_list/1.1.Greg_lab_Ben_2013_74.txt"
df1a <- dplyr::filter(df1, tag1 > 0)
readr::write_delim(df1a, f1a, na = "n.d.", col_names = TRUE)
## tag2: mean_value <= -1.5 (n=216)
f1a  <- "data/raw_list/1.2.Greg_lab_Ben_2013_216.txt"
df1a <- dplyr::filter(df1, tag2 > 0)
readr::write_delim(df1a, f1a, na = "n.d.", col_names = TRUE)
## tag3: at least 2 TEs, <= -2.0 (n=137)
f1a  <- "data/raw_list/1.3.Greg_lab_Ben_2013_137.txt"
df1a <- dplyr::filter(df1, tag3 > 0)
readr::write_delim(df1a, f1a, na = "n.d.", col_names = TRUE)
## tag4: at least 1 TEs, <= -2.0 (n=377)
f1a  <- "data/raw_list/1.4.Greg_lab_Ben_2013_377.txt"
df1a <- dplyr::filter(df1, tag4 > 0)
readr::write_delim(df1a, f1a, na = "n.d.", col_names = TRUE)

#------------------------------------------------------------------------------#
# 2. Julius lab, Handler 2013
#------------------------------------------------------------------------------#
# Handler, 2013 (Julis lab)
# table S1: https://ars.els-cdn.com/content/image/1-s2.0-S1097276513003365-mmc2.xlsx
#
# Table S1. Primary and Verified Results of the Screen.
#
# genes (staining)
# 49 (>=2)
# 80 (>=1.5)
# 144 (>=1)
fileURL <- "https://ars.els-cdn.com/content/image/1-s2.0-S1097276513003365-mmc2.xlsx"
fileTableS1 <- "data/raw_list/2.0.Julius_lab_Handler_2013.TableS1.xlsx"
# download.file(fileURL, fileTableS1, method = "curl")
#
# loading data from Excel file (13948 rows, 11 columns)
df2 <- readxl::read_xlsx(fileTableS1, trim_ws = TRUE, skip = 1) %>% 
  dplyr::select(c(1, 2, 4, 6, 7, 9:14)) 
colnames(df2) <- c(
  "Symbol", "CG", "RPKM", "staining", "morphology", "VDRC_1", "staining_1", "morphology_1", 
  "VDRC_2", "staining_2", "morphology_2"
)
# fix NA values in staining
df2$staining[is.na(df2$staining)] <- 0
print(dim(df2))
# Assign a new column "status" based on the "staining" column
df2 <- df2 %>%
  mutate(
    status = case_when(
      staining == 0   ~ "no staining",
      staining == 1   ~ "weak staining",
      staining == 1.5 ~ "intermediate-weak staining",
      staining == 2   ~ "intermediate staining",
      staining == 2.5 ~ "strong-intermediate staining",
      staining == 3   ~ "strong staining",
      TRUE ~ "no staining"  # Handle any other values (optional)
    )
  )
# filter records by staining
#-------------------------#
# threshold: staining
#-------------------------#
## 1. >= 2.0 (n=49)
## 2. >= 1.5 (n=80)
## 3. >= 1.0 (n=144)
df2 <- dplyr::mutate(
  df2, 
  tag1 = as.numeric(staining >= 2),
  tag2 = as.numeric(staining >= 1.5),
  tag3 = as.numeric(staining >= 1)
)
colSums(dplyr::select(df2, contains("tag")))
#-------------------------#
# save each table to files
#-------------------------#
## tag1: staining >= 2.0 (n=49)
f2a  <- "data/raw_list/2.1.Julius_lab_Handler_2013_49.txt"
df2a <- dplyr::filter(df2, tag1 > 0)
readr::write_delim(df2a, f2a, na = "n.d.", col_names = TRUE)
## tag1: staining >= 1.5 (n=80)
f2a  <- "data/raw_list/2.2.Julius_lab_Handler_2013_80.txt"
df2a <- dplyr::filter(df2, tag2 > 0)
readr::write_delim(df2a, f2a, na = "n.d.", col_names = TRUE)
## tag1: staining >= 1.0 (n=144)
f2a  <- "data/raw_list/2.3.Julius_lab_Handler_2013_144.txt"
df2a <- dplyr::filter(df2, tag3 > 0)
readr::write_delim(df2a, f2a, na = "n.d.", col_names = TRUE)

#------------------------------------------------------------------------------#
# 3. Greg lab, Muerdter 2013
#------------------------------------------------------------------------------#
# Muerdter, 2013 (Greg lab)
# table S1: https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002876-mmc2.xlsx
# table S3: https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002876-mmc3.xlsx
# Table S1. Primary Screen Results, Related to Figure 1.
# Table S3. Validation Screen Results, Related to Figure 2.
#
# genes (validated)
# 86 (va)
# 
fileURL <- "https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002876-mmc3.xlsx"
fileTableS3 <- "data/raw_list/3.0.Greg_lab_Muertder_2013.TableS3.xlsx"
# download.file(fileURL, fileTableS3, method = "curl")
#
# loading data (341 rows, 8 columns)
df3 <- readxl::read_xlsx(fileTableS3, trim_ws = TRUE)
colnames(df3) <- c(
  "FBID", "TRANSID", "Symbol", "Fertility", "fc_gypsy", "fc_gypsy3", "fc_ZAM", "status"
)
print(dim(df3))
# unique gene_id (292)
df3 <- dplyr::select(df3, FBID, Symbol, status) %>%
  unique
print(dim(df3))
print(table(df3$status))
# va, validated genes (n=87)
# dd, development defect, (n=52)
# nv, non validated, (n=149)
#-------------------------#
# save each table to files
#-------------------------#
## tag1: va, validated (n=87)
f3a  <- "data/raw_list/3.1.Greg_lab_Muerdter_2013_87.txt"
df3a <- dplyr::filter(df3, status == "va")
readr::write_delim(df3a, f3a, na = "n.d.", col_names = TRUE)
## tag2: dd, development defect (n=52)
f3a  <- "data/raw_list/3.2.Greg_lab_Muerdter_2013_52.txt"
df3a <- dplyr::filter(df3, status == "dd")
readr::write_delim(df3a, f3a, na = "n.d.", col_names = TRUE)
## tag3: nv, non validated (n=149)
f3a  <- "data/raw_list/3.3.Greg_lab_Muerdter_2013_149.txt"
df3a <- dplyr::filter(df3, status == "nv")
readr::write_delim(df3a, f3a, na = "n.d.", col_names = TRUE)


#------------------------------------------------------------------------------#
# fix gene names: FBID, CGID, symbol
#------------------------------------------------------------------------------#
# ## biomart
### manually, from FlyBase

message("Combine all fixed table")

library(readxl)
#---------------------------------#
# 1. Greg lab, Ben 2013
#---------------------------------#
f1 <- "data/fixed_list/1.Ben_2013.xlsx"
sheets <- readxl::excel_sheets(f1)
sheets <- sheets[grep("n=", sheets)]
df1 <- lapply(sheets, function(i) {
  # group: ben_74, ben_216, ben_137, ben_377
  df <- read_xlsx(f1, sheet = i) %>% dplyr::select(1:4)
  # fix
  colnames(df) <- c("num", "gene_id", "cg_id", "symbol")
  df$group <- gsub("n=", "ben_", i)
  df
}) %>%
  dplyr::bind_rows()
print(table(df1$group))

#---------------------------------#
# 2. Julius lab, Handler 2013
#---------------------------------#
f2 <- "data/fixed_list/2.Handler_2013.xlsx"
sheets <- readxl::excel_sheets(f2)
sheets <- sheets[grep("n=", sheets)]
df2 <- lapply(sheets, function(i) {
  # group: handler_144, handler_49, handler_80
  df <- read_xlsx(f2, sheet = i) %>% dplyr::select(1:4)
  # fix
  colnames(df) <- c("num", "gene_id", "cg_id", "symbol")
  df$group <- gsub("n=", "handler_", i)
  df
}) %>%
  dplyr::bind_rows()
print(table(df2$group))

#---------------------------------#
# 3. Greg lab, Muerdterdler 2013
#---------------------------------#
f3 <- "data/fixed_list/3.Muerdter_2013.xlsx"
sheets <- readxl::excel_sheets(f3)
sheets <- sheets[grep("n=", sheets)]
df3 <- lapply(sheets, function(i) {
  # group: muerdter_149, muerdter_52, muerdter_87
  df <- read_xlsx(f3, sheet = i) %>% dplyr::select(1:4)
  # fix
  colnames(df) <- c("num", "gene_id", "cg_id", "symbol")
  df$group <- gsub("n=", "muerdter_", i)
  df
}) %>%
  dplyr::bind_rows()
print(table(df3$group))

#---------------------------------#
# 4. combine all three tables
#---------------------------------#
df <- dplyr::bind_rows(df1, df2, df3)
print(table(df$group))
readr::write_csv(df, "data/fixed_list/screen_hits.full_list.csv")

#---------------------------------#
# 5. Final selection
#---------------------------------#

#---------------------------------#
# ben_137, handler_144, muerdter_87
#---------------------------------#
dfs <- dplyr::filter(
  df, group %in% c("ben_137", "handler_144", "muerdter_87")
) %>%
  dplyr::mutate(num = 1) %>%
  tidyr::pivot_wider(names_from = "group", values_from = "num") %>%
  dplyr::arrange(gene_id) %>%
  dplyr::mutate(sum = rowSums(dplyr::select(., 4:6), na.rm = TRUE))
dfs[is.na(dfs)] <- 0
readr::write_csv(dfs, "data/fixed_list/screen_hits.137_144_87.csv")

#---------------------------------#
# ben_377, handler_144, muerdter_87
#---------------------------------#
dfs <- dplyr::filter(
  df, group %in% c("ben_377", "handler_144", "muerdter_87")
) %>%
  dplyr::mutate(num = 1) %>%
  unique() %>%
  tidyr::pivot_wider(names_from = "group", values_from = "num") %>%
  dplyr::arrange(gene_id) %>%
  dplyr::mutate(sum = rowSums(dplyr::select(., 4:6), na.rm = TRUE))
dfs[is.na(dfs)] <- 0
readr::write_csv(dfs, "data/fixed_list/screen_hits.377_144_87.csv")

#---------------------------------#
# ben_74, handler_49, muerdter_87
#---------------------------------#
dfs <- dplyr::filter(
  df, group %in% c("ben_74", "handler_49", "muerdter_87")
) %>%
  dplyr::mutate(num = 1) %>%
  tidyr::pivot_wider(names_from = "group", values_from = "num") %>%
  dplyr::arrange(gene_id) %>%
  dplyr::mutate(sum = rowSums(dplyr::select(., 4:6), na.rm = TRUE))
dfs[is.na(dfs)] <- 0
readr::write_csv(dfs, "data/fixed_list/screen_hits.74_49_87.csv")

#---------------------------------#
# ben_74, handler_80, muerdter_87
#---------------------------------#
dfs <- dplyr::filter(
  df, group %in% c("ben_74", "handler_80", "muerdter_87")
) %>%
  dplyr::mutate(num = 1) %>%
  tidyr::pivot_wider(names_from = "group", values_from = "num") %>%
  dplyr::arrange(gene_id) %>%
  dplyr::mutate(sum = rowSums(dplyr::select(., 4:6), na.rm = TRUE))
dfs[is.na(dfs)] <- 0
readr::write_csv(dfs, "data/fixed_list/screen_hits.74_80_87.csv")

#---------------------------------#
# ben_74, handler_144, muerdter_87
#---------------------------------#
dfs <- dplyr::filter(
  df, group %in% c("ben_74", "handler_144", "muerdter_87")
) %>%
  dplyr::mutate(num = 1) %>%
  tidyr::pivot_wider(names_from = "group", values_from = "num") %>%
  dplyr::arrange(gene_id) %>%
  dplyr::mutate(sum = rowSums(dplyr::select(., 4:6), na.rm = TRUE))
dfs[is.na(dfs)] <- 0
readr::write_csv(dfs, "data/fixed_list/screen_hits.74_144_87.csv")

#---------------------------------#
# all groups
#---------------------------------#
dfs <- df %>%
  dplyr::mutate(num = 1) %>%
  unique() %>%
  tidyr::pivot_wider(names_from = "group", values_from = "num") %>%
  dplyr::arrange(gene_id) %>%
  dplyr::mutate(sum = rowSums(dplyr::select(., - c(1:3)), na.rm = TRUE))
dfs[is.na(dfs)] <- 0
readr::write_csv(dfs, "data/fixed_list/screen_hits.all_groups.csv")

#------------------------------------------------------------------------------#
# 6. Yulab further validation [137-144-87]
#------------------------------------------------------------------------------#
# selection:
dfs <- dplyr::filter(
  df, group %in% c("ben_137", "handler_144", "muerdter_87")
) %>%
  dplyr::mutate(num = 1) %>%
  tidyr::pivot_wider(names_from = "group", values_from = "num") %>%
  dplyr::arrange(gene_id) %>%
  dplyr::mutate(sum = rowSums(dplyr::select(., 4:6), na.rm = TRUE))
dfs[is.na(dfs)] <- 0
## 1. not tested (n=52)
f1_nt <- "data/fixed_list/screen_hits.137_144_87.not_test.id.csv"
id_nt <- readr::read_csv(f1_nt, show_col_types = F)
df_nt <- dplyr::right_join(dfs, id_nt, by = "gene_id", keep = F)
readr::write_csv(df_nt, "data/fixed_list/screen_hits.137_144_87.not_test.csv")

# tested genes
f2_ts <- "data/fixed_list/screen_hits.137_144_87.test.id.csv"
id_ts <- readr::read_csv(f2_ts, show_col_types = F)
df_ts <- dplyr::right_join(dfs, id_ts, by = "gene_id", keep = F)
readr::write_csv(df_ts, "data/fixed_list/screen_hits.137_144_87.test.csv")


