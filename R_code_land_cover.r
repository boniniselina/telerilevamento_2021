#R_code_land_cover.r

library(raster)
library(RStoolbox)
#install.packages("ggplot2")
library(ggplot2)
#install.packages("gridExtra")
library(gridExtra)

setwd("C:/lab/deforestazione")


defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")

#per confrontarle
par(mfrow=c(1,2))
plotRGB(defor1, 1, 2, 3, stretch="Lin")
plotRGB(defor2, 1, 2, 3, stretch="Lin")

# ggRGB ha bisogno dell'immagine da plottare, delle bande montate r, g, b, e lo stretch
ggRGB(defor1, 1, 2, 3, stretch="Lin") #plotta l'immagine con gli assi cartesiani
ggRGB(defor2, 1, 2, 3, stretch="Lin")

#per confrontare i due ggRGB non è possibile utilizzare il par. ci vuole una funzione specifica
p1 <- ggRGB(defor1, 1, 2, 3, stretch="Lin")
p2 <- ggRGB(defor2, 1, 2, 3, stretch="Lin")
grid.arrange(p1, p2, nrow=2) #possiamo arrangiare qualsiasi tipo di griglia

