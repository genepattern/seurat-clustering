## The Regents of the University of California and The Broad Institute
## SOFTWARE COPYRIGHT NOTICE AGREEMENT
## This software and its documentation are copyright (2018) by the
## Regents of the University of California abd the
## Broad Institute/Massachusetts Institute of Technology. All rights are
## reserved.
##
## This software is supplied without any warranty or guaranteed support
## whatsoever. Neither the Broad Institute nor MIT can be responsible for its
## use, misuse, or functionality.

# Load any packages used to in our code to interface with GenePattern.
# Note the use of suppressMessages and suppressWarnings here.  The package
# loading process is often noisy on stderr, which will (by default) cause
# GenePattern to flag the job as failing even when nothing went wrong.
suppressMessages(suppressWarnings(library(getopt)))
suppressMessages(suppressWarnings(library(optparse)))
suppressMessages(suppressWarnings(library(dplyr)))
suppressMessages(suppressWarnings(library(Seurat)))

# Print the sessionInfo so that there is a listing of loaded packages,
# the current version of R, and other environmental information in our
# stdout file.  This can be useful for reproducibility, troubleshooting
# and comparing between runs.
sessionInfo()

is.emptyString=function(a){return (trimws(a)=="")}

# Get the command line arguments.  We'll process these with optparse.
# https://cran.r-project.org/web/packages/optparse/index.html
arguments <- commandArgs(trailingOnly=TRUE)

# Declare an option list for optparse to use in parsing the command line.
option_list <- list(
  # Note: it's not necessary for the names to match here, it's just a convention
  # to keep things consistent.
  make_option("--input.file", dest="input.file"),
  make_option("--output.file", dest="output.file"),
  make_option("--max_dim", dest="max_dim", type="integer"),
  make_option("--resolution", dest="resolution", type="double"),
  make_option("--reduction", dest="reduction"),
  make_option("--nmarkers", dest="nmarkers",type="integer"),
  make_option("--seed", dest="seed",type="integer")

)

# Parse the command line arguments with the option list, printing the result
# to give a record as with sessionInfo.
opt <- parse_args(OptionParser(option_list=option_list), positional_arguments=TRUE, args=arguments)
print(opt)
opts <- opt$options

pbmc=NULL

if (file.exists(opts$input.file)){
	pbmc = readRDS(opts$input.file)
}
pdf(paste(opts$output.file, ".pdf", sep=""))

print('FindNeighbors')
pbmc <- FindNeighbors(pbmc, dims = 1:opts$max_dim)
print('FindClusters')
pbmc <- FindClusters(pbmc, resolution = opts$resolution)
print('RunUMAP')
pbmc <- RunUMAP(pbmc, dims = 1:opts$max_dim, seed.use=opts$seed)
print('DimPlot')
DimPlot(pbmc, reduction = opts$reduction)
# print("There are this many clusters")

# saveRDS(pbmc, file = paste(opts$output.file, ".rds", sep=""))

# 2020-01-14 EFJ adding the next steps

# find all markers of cluster 1
# cluster1.markers <- FindMarkers(pbmc, ident.1 = 1, min.pct = 0.25)
# head(cluster1.markers, n = 5)

#ADD min.pc and logfc.threshold as MODULE PARAMETERS
# find markers for every cluster compared to all remaining cells, report only the positive ones
print('Finding markers for all clusters.')
pbmc.markers <- FindAllMarkers(pbmc, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
print('Here are the top markers for each cluster')

suppressMessages(suppressWarnings(library(Seurat)))
pbmc.markers %>% group_by(cluster) %>% top_n(n = opts$nmarkers, wt = avg_log2FC)

print('Writing csv files, this may take a little while.')
write.csv(pbmc.markers %>% group_by(cluster) %>% top_n(n = opts$nmarkers, wt = avg_log2FC),paste(opts$output.file, ".csv", sep=""), row.names = FALSE)
write.csv(pbmc.markers %>% group_by(cluster) %>% top_n(n = n(), wt = avg_log2FC),paste(opts$output.file, "_all_markers.csv", sep=""), row.names = FALSE)

# This is too specific to PBMC, so it won't be implemented
# new.cluster.ids <- c("Naive CD4 T", "Memory CD4 T", "CD14+ Mono", "B", "CD8 T", "FCGR3A+ Mono",
#     "NK", "DC", "Platelet")
# names(new.cluster.ids) <- levels(pbmc)
# pbmc <- RenameIdents(pbmc, new.cluster.ids)
# DimPlot(pbmc, reduction = "umap", label = TRUE, pt.size = 0.5) + NoLegend()

# saveRDS(pbmc, file = "../output/pbmc3k_final.rds")

#removing ".rds" in case it was there
saveRDS(pbmc, file = paste(opts$output.file, ".rds", sep=""))
#saveRDS(pbmc, file = paste(str_remove(opts$output.file, "\b.rds\b"), ".rds", sep=""))
print("All done, move along!")
