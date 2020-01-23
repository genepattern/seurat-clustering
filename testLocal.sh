rm -rf Job_1/*

docker run -v $PWD:$PWD -w $PWD/Job_1 -t genepattern/seurat-clustering:1.0 /opt/R3.6/bin/Rscript --no-save --quiet --slave --no-restore  $PWD/run_seurat_clustering.R  --input.file=$PWD/test/data/pbmc_preprocessed.rds --output.file=postmarker --max_dim=10 --resolution=0.5 --reduction=umap --nmarkers=4
