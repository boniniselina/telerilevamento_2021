#Analisi multitemporale in Groenlandia: potenziale aumento della temperatura ed evoluzione dei ghiacciai
#Dati semplificati da Emanuela Cosma

install.packages("raster")
library(raster)
setwd("C:/lab/Greenland")

#le immagini rappresentano la stima della temperatura derivanti dal programma Copernicus
#media di 10 giorni di giugno negli anni 2000, 2005, 2010 e 2015

#usiamo la funzione raster() per prendere il dataset 
lst_2000 <- raster("lst_2000.tif")
lst_2005 <- raster("lst_2005.tif")
lst_2010 <- raster("lst_2010.tif")
lst_2015 <- raster("lst_2015.tif")

#ammettiamo che le Temperature siano misurate in gradi centigradi. 
#il peso dell'immagine finale, soprattutto se ci sono decimali, sarebbe molto gande
#le immagini che utilizziamo pesano solamente 8,5M --> vengono utilizzati valori INTERI
#il passaggio viene eseguito attraverso il concetto di BIT = spazio di informazioni nero=1, bianco=0
#esempi:
#2 bit = 2^2 spazi -> 00(bianco) / 01(grigio) / 10(grigio scuro) / 11(nero)
#se 3 bit = 2^3 spazi = 8
#molte immagini sono a 8 bit = 256 valori
#le nostre sono immagini codificate a 16 bit con valori ripetuti, il peso dell'immagine diminuisce
#2^16 = 65536 valori
#maggiore è il valore della mappa digitale e maggiore è la temperatura!

#per vederle tutte e quattro insieme in un plot in due righe e due colonne
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

#creo una lista di file che hanno lo stesso nome e che chiamo rlist
rlist <- list.files(pattern="lst")

# funzione che permette di applicare una funzione ad una lista di file
import <- lapply(rlist,raster) #come argomenti = nome lista, nome funzione

#costruire il pacchetto di file tutti insieme che chiamo TGr utilizzando la funzione stack
TGr <- stack(import) 
plot(TGr)

# r=2000 / g=2005 / b=2010
plotRGB(TGr,1,2,3, stretch="Lin")

#Installare pacchetto rasterVis
install.packages("rasterVis")

