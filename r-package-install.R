sessionInfo()

qwc = function(...) { as.character( unlist( as.list( match.call() )[ -1 ] ) ) }

install_it = function() {
mylist = ( qwc (
##Biostrings,
DT,
devtools,
##GEOquery,
GGally,
Hmisc,
RCurl,
Rtsne,
amap,
bigmemory,
boot,
clusterProfiler,
cowplot,
data.table,
doMC,
doParallel,
editData,
enrichplot,
factoextra,
flextable,
foreach,
ggpubr,
ggridges,
ggthemes,
glue,
gridExtra,
gtable,
knitr,
officer,
openssl,
openxlsx,
org.Mm.eg.db,
org.Hs.eg.db,
patchwork,
pheatmap,
plot,
plotly,
plotrix,
plyr,
pROC,
pool,
ppcor,
printr,
psych,
qgraph,
qlcMatrix,
reshape2,
reticulate,
Rgraphviz,
rmarkdown,
scales,
shinyBS,
shinybusy,
shinycssloaders,
shinydashboard,
shinyjs,
shinythemes,
stringdist,
stringr,
tidyverse,
topGO,
umap,
viridis
) )
  for ( i in mylist ) {
  ##try(remove.packages( i, '/usr/local/lib/R/library') )
  ##try(remove.packages( i, '/usr/local/lib/R/site-library') )
  install.packages(i)
} } 

install_it()
