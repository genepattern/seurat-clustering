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
#suppressMessages(suppressWarnings(library(dplyr)))
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
  make_option("--seed", dest="seed", type="integer"),

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

pbmc <- FindNeighbors(pbmc, dims = 1:opts$max_dim)
pbmc <- FindClusters(pbmc, resolution = opts$resolution)
pbmc <- RunUMAP(pbmc, dims = 1:opts$max_dim, seed.use=opts$seed)
DimPlot(pbmc, reduction = opts$reduction)
saveRDS(pbmc, file = opts$output.file)





