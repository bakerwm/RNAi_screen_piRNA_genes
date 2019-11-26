


## RNAi screen
# setwd("~/wm_work/RNAi_screen_fruitfly/")
# setwd("D:/坚果云sync/我的坚果�?/工作目录/20191123-RNAi-screen/RNAi_screen_fruitfly/")

library(readr)
library(readxl)
library(tidyr)
library(tibble)

# mn <- c("CG5499", "CG42724", "CG43081", "CG4548", "CG9537")

## Reference
# 1.	Czech, B., Preall, J. B., McGinn, J. & Hannon, G. J. A Transcriptome-wide RNAi Screen in the Drosophila Ovary Reveals Factors of the Germline piRNA Pathway. Mol. Cell 50, 749�?761 (2013).
# 2.	Handler, D. et al. The Genetic Makeup of the Drosophila piRNA Pathway. Mol. Cell 50, 762�?777 (2013).
# 3.	Muerdter, F. et al. A Genome-wide RNAi Screen Draws a Genetic Framework for Transposon Control and Primary piRNA Biogenesis in Drosophila. Mol. Cell 50, 736�?748 (2013).


## 1. Ben
##
## Benjamin Czech, 2013 (Greg lab)
## table S1: https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002888-mmc2.xlsx
## 
## Table S1. Raw Data for Primary Screen, Related to Figure 2. Shown are transformant IDs (of VDRC stock center; TID), library (Lib), viability of fly stock, and chromosome insertion (Chr) of the dsRNA for all 8,171 RNAi lines used. Gene IDs and synonyms are shown along with raw Z scores for HeTA, TAHRE, blood, and burdock.
##
## derepression threshold, Z-score
## genes; Z-score
## 74    -2.0
## 216   -1.5
## 137   -2.0 in at least two TE
## 377   -2.0 in at least one TE
fileURL <- "https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002888-mmc2.xlsx"
fileTableS1  <- "data/1.Ben_2013_Greg_lab/TableS1.xlsx"
# download.file(fileURL, fileTableS1, method = "curl")

## including NA values (n.d.)
## 8171 records
df <- readxl::read_xlsx(fileTableS1, na = "n.d.") %>%
  dplyr::mutate(HeTA = as.numeric(HeTA),
                TAHRE = as.numeric(TAHRE),
                blood = as.numeric(blood),
                burdock = as.numeric(burdock))

## 8133 records
df$mean <- df[, 5:8] %>%
  rowMeans(na.rm = TRUE)
df <- dplyr::arrange(df, mean)

## df <- df[complete.cases(df), ]
df[is.na(df)] <- 0 

## threshold: -2.0 for each condition
df$status <- purrr::map(df[, 5:8], function(x) x <= -2.0) %>% 
  as.data.frame() %>%
  rowSums()

## threshold: -2.0, -1.5
sum(df$mean <= -2.0) # 74
sum(df$mean <= -1.5) # 216
sum(df$status >= 2)  # 137, at least in two TE
sum(df$status >= 1)  # 377, at least in two TE

## total
df <- df %>%
  dplyr::filter(status >= 1)

## save to table
file1 <- "data/1.Ben_2013_Greg_lab/01_screen_Ben_377.txt"
readr::write_delim(df, file1, na = "n.d.", col_names = TRUE) 

## 74 genes
df2 <- df %>%
  dplyr::filter(mean <= -2.0)

file2 <- "data/1.Ben_2013_Greg_lab/01_screen_Ben_74.txt"
readr::write_delim(df2, file2, na = "n.d.", col_names = TRUE) 






## 2. Handler
##
## Handler, 2013 (Julis lab)
## table S1: https://ars.els-cdn.com/content/image/1-s2.0-S1097276513003365-mmc2.xlsx
##
## Table S1. Primary and Verified Results of the Screen.
##
## genes (staining)
## 49 (>=2)
## 80 (>=1.5)
## 144 (>=1)
fileURL <- "https://ars.els-cdn.com/content/image/1-s2.0-S1097276513003365-mmc2.xlsx"
fileTableS1 <- "data/2.Handler_2013_Julius_lab/TableS1.xlsx"
# download.file(fileURL, fileTableS1, method = "curl")

## including blanks
df <- readxl::read_xlsx(fileTableS1, trim_ws = TRUE, skip = 1) %>% 
  dplyr::select(c(1, 2, 4, 6, 7, 9:14)) 

names(df) <- c("Symbol", "CG", "RPKM", "staining", "morphology",
               "VDRC_1", "staining_1", "morphology_1", 
               "VDRC_2", "staining_2", "morphology_2")
## staining
df_staining <- data.frame(
  value = c(0, 1, 1.5, 2, 2.5, 3),
  status = c("no staining", "weak staining",
             "intermediate-weak staining", "intermediate staining",
             "strong-intermediate staining", "strong staining"),
  stringsAsFactors = FALSE
)

df <- df %>% 
  dplyr::mutate(status = plyr::mapvalues(staining, 
                                         from = df_staining$value,
                                         to = df_staining$status))
# df <- df[complete.cases(df), ]
df[is.na(df)] <- 0

sum(df$staining >= 2)   # 49
sum(df$staining >= 1.5) # 80
sum(df$staining >= 1)   # 144

## pick 144 genes
df <- df %>%
  dplyr::filter(staining >= 1)

## save to table
file1 <- "data/2.Handler_2013_Julius_lab/02_screen_Handler_144.txt"
readr::write_delim(df, file1, na = "n.d.", col_names = TRUE)

## 80 genes
df2 <- df %>%
  dplyr::filter(staining >= 1.5)
##
file2 <- "data/2.Handler_2013_Julius_lab/02_screen_Handler_80.txt"
readr::write_delim(df2, file2, na = "n.d.", col_names = TRUE)



## 3. Muerdter 
##
## Muerdter, 2013 (Greg lab)
## table S1: https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002876-mmc2.xlsx
## table S3: https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002876-mmc3.xlsx
## Table S1. Primary Screen Results, Related to Figure 1.
## Table S3. Validation Screen Results, Related to Figure 2.
##
## genes (validated)
## 86 (va)
## 
fileURL <- "https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002876-mmc3.xlsx"
fileTableS3 <- "data/3.Muertder_2013_Greg_lab/TableS3.xlsx"
# download.file(fileURL, fileTableS3, method = "curl")

## parsing data
df <- readxl::read_xlsx(fileTableS3, trim_ws = TRUE)
colnames(df) <- c("FBID", "TRANSID", "Symbol", "Fertility",
                  "fc_gypsy", "fc_gypsy3", "fc_ZAM", "status")

## 87 validated genes
length(
  df %>% 
    dplyr::filter(status %in% c("va")) %>%
    dplyr::pull("FBID") %>%
    unique())

## 52 dev defect
length(
  df %>% 
    dplyr::filter(status %in% c("dd")) %>%
    dplyr::pull("FBID") %>%
    unique())

## only va genes
df <- df %>% 
  dplyr::filter(status %in% c("va"))


## save to table
file <- "data/3.Muertder_2013_Greg_lab/03_screen_Muerdter_87.txt"
readr::write_delim(df, file, na = "n.d.", col_names = TRUE)

##----------------------------------------------------------------------------##
## format output
##
## FBID Symbol CG screen1 screen2 screen3 status description
