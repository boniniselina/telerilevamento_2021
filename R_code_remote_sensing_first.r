# Il mio primo codice in R per  il Telerilevamento

#Imposto la working directory su Windows
setwd("C:/lab/")

#Installo il pacchetto "raster"
#install.packages("raster")
library(raster)

#carico le immagini satellitari con la funzione brick()
p224r63_2011 <- brick("p224r63_2011_masked.grd")
plot(p224r63_2011) #visualizzo le singole bande di riflettanza
