# copyright 2017-2018 Regents of the University of California and the Broad Institute. All rights reserved.
FROM genepattern/genepattern-notebook:19.12.1

MAINTAINER Edwin Juarez <ejuarez@ucsd.edu>

ENV LANG=C LC_ALL=C
USER root

#RUN conda install -y -c bioconda r-seurat==2.3.4
#RUN conda install -y -c bioconda r-seurat==3.0.2

#=========================================================================
#Did not work:
#RUN R -e "install.packages('devtools')"
#RUN R -e "require(devtools)"
#RUN R -e "install_version('Seurat', version = '3.1.0', dependencies= T)"
#=========================================================================

RUN mkdir /seurat
RUN chown  $NB_USER /seurat
USER $NB_USER

# RUN source activate python3.6
COPY install_stuff.R /seurat/install_stuff.R
RUN /opt/R3.6/bin/Rscript /seurat/install_stuff.R
RUN pip install umap-learn
COPY run_seurat_clustering.R /seurat/run_seurat_clustering.R
USER root
RUN chmod -R a+rwx /seurat
#USER $NB_USER

ENTRYPOINT []

