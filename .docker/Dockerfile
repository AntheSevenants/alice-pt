FROM rocker/rstudio:4

RUN R -q -e 'install.packages(c("magrittr", "glmnet", "doMC", "lme4"))'

RUN echo "setwd(\"/home/rstudio/alice-pt/\")" > ~/../home/rstudio/.Rprofile