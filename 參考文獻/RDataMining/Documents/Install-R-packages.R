
## install R packages from CRAN
packages <- c("arules", "arulesViz", "cluster", "data.table", "fpc", 
              "ggplot2", "graph", 
              "Hmisc", "igraph", "knitr", "party", 
              "randomForest", "rgl", "ROCR", "RODBC", 
              "scatterplot3d", "SnowballC",
              "TH.data", "topicmodels", "tm", "twitteR", 
              "wordcloud", "xlsx")
install.packages(packages)


## install R packages from Bioconductor
source("http://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")

