
# RNAi screen for piRNA pathway genes


In 2013, **3** papers applied RNAi screens for piRNA pathway genes were published on **Molecular Cell** in the same volumn, from two research groups: [Greg Lab](https://www.cruk.cam.ac.uk/author/greg-hannon) and [Julius Lab](https://www.imba.oeaw.ac.at/research/julius-brennecke/). This documents aimed to extract overlap genes between screens.

## Details of each screen

### 1. Benjamin Czech, 2013 (Greg lab)

[table S1](https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002888-mmc2.xlsx).    

Table S1. Raw Data for Primary Screen, Related to Figure 2. Shown are transformant IDs (of VDRC stock center; TID), library (Lib), viability of fly stock, and chromosome insertion (Chr) of the dsRNA for all 8,171 RNAi lines used. Gene IDs and synonyms are shown along with raw Z scores for HeTA, TAHRE, blood, and burdock.

**Where**

  - Ovary, Germline specific genes

**How**

  - TE derepression upon knockdown of given genes.

**What** 
  
  - knock down genes by dsRNA;   
  - Check the expression of TEs (HetA, TAHRE, blood, burdock); (derepression); (LINE:HeT-A, TAHRE; LTR: blood, burdock), armi=positive, white=negative;
  - Filter by Z-score;  

**Results**
  
  - A total of 8171 genes were screened. [table S1](https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002888-mmc2.xlsx).
  - 74 genes (Average Z-score <= -2.0) ;   
  - 216 genes (Average Z-score <= -1.5) ;   
  - 137 genes (Z-score <= -2.0, at least in two TEs) ;    
  - 377 genes (Z-score <= -2.0, at least in one TE) ;    

See [table S1](https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002888-mmc2.xlsx) for details.



### 2. Handler, 2013 (Julis lab)

[table S1](https://ars.els-cdn.com/content/image/1-s2.0-S1097276513003365-mmc2.xlsx), 

Table S1. Primary and Verified Results of the Screen.

**Where**

  - Ovary; somatic piRNA pathway

**What**
  
  - reporter: gypsy-LTR + beta-gal (controled by flam derived piRNAs)    
  - X-gal staining

**How**
  
  - The expression of flam was controled by piRNA pathway. (repression, no staining, white)    
  - The repression of flam was disrupted by specific gene knockdown (staining, blue)

**Results**
  
  - 49 genes, (staining >=2) ;      
  - 80 genes, (staining >= 1.5) ;   
  - 144 genes, (staining >= 1) ;
  
**Notes**

  - 7257 genes expressed in OSC (RPKM >= 1).    
  - VDRC 6818 genes, (2 crosses per gene).


See [tabld S1](https://ars.els-cdn.com/content/image/1-s2.0-S1097276513003365-mmc2.xlsx) for details.



### 3. Muerdter, 2013 (Greg lab)

**Where**

  - OSS celline


**What**   
  
  - Check gypsy, ZAM, gypsy3 expression by qPCR ;    
  - TE derepression upon knockdown (KD) of any given genes


**How**  
  
  - genes were knockdown by dsRNA


**Results**
  
  - 87 genes, validated     
  - 52 genes, development defect      
  - 149 genes, non validated    

**Notes**

  - H3K9me3 decreased, piRNA levels not changed.

see [table S3](https://ars.els-cdn.com/content/image/1-s2.0-S1097276513002876-mmc3.xlsx) for details.





## Overlap genes


### 1. Group1: 74-49-87

Candidate genes:  
  
  - 74 genes, Czech Benjamin (Greg lab)    
  
  - 49 genes, Handler Dominik (Julius lab)    
  
  - 87 genes, Muerdter Felix (Greg lab)  

The positive genes reported in each screen.


![](https://github.com/bakerwm/RNAi_screen_piRNA_genes/blob/master/RNAi_screen_fruitfly_files/figure-html/group1-1.png)


### 2. Group2: 377-144-87

Candidate genes:  
  
  - 377 genes, Czech Benjamin (Greg lab)    
  
  - 144 genes, Handler Dominik (Julius lab)    
  
  - 87 genes, Muerdter Felix (Greg lab)  

For Benjamin screen, instead use average Z-score of four TEs <= -2.0 (74 genes), at least Z-score <= -2.0 for **one** TE. (377 genes).  

For Dominik screen, change the criteria of staining from 2.0 (49 genes) to 1.0 (144 genes).




![](https://github.com/bakerwm/RNAi_screen_piRNA_genes/blob/master/RNAi_screen_fruitfly_files/figure-html/group2-1.png)




### 3. Group2: 137-144-87

Candidate genes:  
  
  - 137 genes, Czech Benjamin (Greg lab)    
  
  - 144 genes, Handler Dominik (Julius lab)    
  
  - 87 genes, Muerdter Felix (Greg lab)  

For Benjamin screen, instead use average Z-score of four TEs <= -2.0 (74 genes), at least Z-score <= -2.0 for **two** TEs. (137 genes).  

For Dominik screen, change the criteria of staining from 2.0 (49 genes) to 1.0 (144 genes).


![](https://github.com/bakerwm/RNAi_screen_piRNA_genes/blob/master/RNAi_screen_fruitfly_files/figure-html/group3-1.png)








## Reference

1.	Czech, B., Preall, J. B., McGinn, J. & Hannon, G. J. A Transcriptome-wide RNAi Screen in the Drosophila Ovary Reveals Factors of the Germline piRNA Pathway. Mol. Cell 50, 749¨C761 (2013). DOI: [10.1016/j.molcel.2013.04.007](https://doi.org/10.1016/j.molcel.2013.04.007)

2.	Handler, D. et al. The Genetic Makeup of the Drosophila piRNA Pathway. Mol. Cell 50, 762¨C777 (2013). DOI: [10.1016/j.molcel.2013.04.031](https://doi.org/10.1016/j.molcel.2013.04.031)    
3.	Muerdter, F. et al. A Genome-wide RNAi Screen Draws a Genetic Framework for Transposon Control and Primary piRNA Biogenesis in Drosophila. Mol. Cell 50, 736¨C748 (2013). DOI: [10.1016/j.molcel.2013.04.006](https://doi.org/10.1016/j.molcel.2013.04.006)    






