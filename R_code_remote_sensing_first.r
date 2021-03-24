# Il mio primo codice in R per  il Telerilevamento

#Imposto la working directory su Windows
setwd("C:/lab/")

#Installo il pacchetto "raster"
#install.packages("raster")
library(raster)

#carico le immagini satellitari con la funzione brick()
p224r63_2011 <- brick("p224r63_2011_masked.grd")
plot(p224r63_2011) #visualizzo le singole bande di riflettanza

#cambio il colore (scala di grigi)
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
# cambio la legenda dei colori per ogni banda
plot (p224r63_2011, col=cl)

#in scala di rosso
cls <- colorRampPalette(c("red","pink","orange","purple")) (200)
> plot(p224r63_2011, col=cls)

#Bande di Landsat
#B1 = Blu
#B2 = verde
#B3 = rosso
#B4 = infrarosso vicino 
#B5 = infrarosso medio 
#B6 = infrarosso lontano o infrarosso termico 
#B7 = infrarosso medio

#pulire la finestra grafica
dev.off()

#plotto solo la banda del blu (B1_sre) dell'immagine p224r63_2011
# uso $ per legare le due cose
plot(p224r63_2011$B1_sre)

#posso plottare con la palette creata in precedenza
plot(p224r63_2011$B1_sre, col=cls)

#plotto due bande una accanto all'altra (es. blu e verde), quindi su una riga e due colonne
par(mfrow=c(1,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

#posso metterle anche su due righe e una colonna
par(mfrow=c(2,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

