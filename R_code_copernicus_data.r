#R_code_Copernicus_data.r
#Visualizing Copernicus data on burned area all over the world

library(raster)

#ci serve anche la libreria ncdf4, bisogna installarla
#install.packages("ncdf4")
library(ncdf4)

#imposto la cartella di lavoro (Windows)
setwd("C:/lab/Copernicus")

#associo il database scaricato ad una variabile utilizzando la funzione raster
#ho un singolo strato
incendi <- raster("c_gls_BA300_202101310000_GLOBE_PROBAV_V1.1.1.nc")
#risoluzione in coordinate geografiche, in gradi
#estensione = da -180 a 180, estensione possibile in longitudine e da -60 a 80 per la latitudine
#variabile misurata il 31 gennaio del 2021

#facciamo un primo plot dei valori
#posso scegliere la scala di colori da utilizzare
#dal celeste (light blu) al verde, al rosso al giallo 
cl <- colorRampPalette(c('light blue','green','red','yellow'))(100)

plot(incendi, col=cl) #nel mio caso non ha molto senso, 
#faccio il plot normale, magari impostando anche il titolo del grafico 
plot(incendi, main="Burned Area - 31/01/2021")

#Ricampionamento (RESAMPLING) 
#ricampionamento bilineare, utile per risparmiare un po' di tempo nel processamento dei dati

#funzione aggregate per aggregare i pixel
#nell'immagine, maggiore è il numero di pixel e maggiore è il suo peso. 
#posso prendere un pixel di dimensioni maggiori e fare una media dei valori dei pixel contenuti
#diminuisco così il numero di pixel di un fattore n --> fact = 10
#con un fattore 10 faccio 10x10, la media di 100 valori mi dà un solo pixel in uscita

#la mia variabile ha 5689958400 celle
#prendo un fattore 10
burnedarea <- aggregate(incendi, fact=10)
plot(burnedarea)
