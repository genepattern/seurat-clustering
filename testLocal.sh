rm -rf Job_1/*
docker run -v $PWD:/LOCAL -w /LOCAL/Job_1 -t genepattern/seurat-suite:4.0.3 Rscript --no-save --quiet --slave --no-restore  /LOCAL/run_seurat_clustering.R  --input.file=/LOCAL/data/test_run.rds --output.file=postmarker --max_dim=10 --resolution=0.5 --reduction=umap --nmarkers=4
