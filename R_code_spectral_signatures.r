# R_code_spectral_signatures.r

# se ci sono dei sensori appositi, è possibile distinguere le firme spettrali di piante/minerali.

library(raster)
library(rgdal)

#impostare la cartella di lavoro su Windows
setwd("C:/lab/deforestazione)

#carichiamo tutte le bande con il brick
defor2 <- brick("defor2.jpg")

#NIR = defor2.1
#red = defor2.2
#green = defor2.3

plotRGB(defor2, r=1, g=2, b=3, stretch="lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="hist")

#creiamo un piccolo dataset di firme spettrali, ci serve la libreria rgdal

click(defor2, 
