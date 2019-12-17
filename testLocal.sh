

docker run -v $PWD:$PWD -w $PWD -t genepattern/seurat-clustering /opt/R3.6/bin/Rscript --no-save --quiet --slave --no-restore  /seurat/run_seurat_clustering.R  --input.file=test/data/pbmc.rds --output.file=postcluster.rds --max_dim=10 --resolution=0.5 --reduction=umap 


