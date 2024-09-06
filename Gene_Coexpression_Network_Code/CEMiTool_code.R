setwd("C:/Users/bruep/OneDrive/Área de Trabalho/zzz_teste/")

################# CEMiTool ########################

# Load normalized gene expression dataset
tab <- read.delim("C:/Users/bruep/OneDrive/Área de Trabalho/Kleiton/Pathways/BROAD_TCGA_tumors_datasets/ACC/TCGA-ACC_GTEX-NormalAdrenalGLand_vst_normalized_gene_expression.txt", row.names=1)

# Adjust a DF with the required format by CEMiTool
expressions <- tab[,1:334]

# Load packages
library(CEMiTool)

# Load the phenotype file of samples
Phenotype <- read.delim("C:/Users/bruep/OneDrive/Área de Trabalho/CEMITOOLS_Agosto_2024/cemitool-phenotype_ACC.txt", row.names=1)

# Prepare sample annotation dataframe
annot = data.frame(SampleName = row.names(Phenotype), Class = Phenotype$Class)

# Read GMT file
gmt_fname <- system.file("extdata", "pathways.gmt", package = "CEMiTool")
gmt_in <- read_gmt(gmt_fname)

# Read interactions
int_fname <- system.file("extdata", "interactions.tsv", package = "CEMiTool")
int_df <- read.delim(int_fname)

# Create the CEMiTool object and perform analysis
cem <- cemitool(as.data.frame(expressions),
                force_beta = F,
                filter = T,
                apply_vst = F,
                annot = annot,
                gmt = gmt_in,
                interactions = int_df,
                verbose = T)

# Load ggplot2 to customize the plots
library(ggplot2)

#
print(cem)

# Create report as pdf and html documents
generate_report(cem, directory = "./Report",
                output_format = "html_document",
                force = T)

# Write analysis results into files
write_files(cem, directory="Report/Tables", force=TRUE)

# Save all plots
save_plots(cem, "all", directory="Report/Plots", force = T)
