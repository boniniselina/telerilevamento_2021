# R_code_variability.r

library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
#install.packages("viridis")
library(viridis)


setwd("C:/lab/similaun/")

#importiamo l'immagine

sent <- brick("sentinel.png")

plotRGB(sent, 1, 2, 3, stretch = "Lin") 
#essendo un'immagine già montata:
#r = infrarosso NIR
#g = rosso RED
#b = verde GREEN
#anche lo stretch lo prende automaticamente perché l'immagine è stata fornita già compattata
#essendo il default, possiamo scrivere anche plotRGB(sent)

plotRGB(sent, 2, 1, 3, stretch = "Lin")  
#la roccia nuda (calcare) è rappresentata in viola
#la parte vegetata è verde brillante
#l'acqua assorbe il NIR ed è nera

#per il calcolo della varianza prendiamo una finestra mobile che scorre lungo i pixel e 
#calcola, ad esempio, la media e la deviazione standard dei valori presenti nei pixel compresi dalla moving window.
#maggiore è la varianza e maggiore sarà la deviazione standard.
#il valore di deviazione standard sono associati al pixel centrale, sui bordi non può calcolarla

#dobbiamo compattare il set di dati in un solo strato 
#possiamo usare, ad esempio, l'NDVI = (NIR-RED) / (NIR + RED)

#per conoscere le informazioni riguardo l'immagine
sent

# class      : RasterBrick 
# dimensions : 794, 798, 633612, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 798, 0, 794  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/similaun/sentinel.png 
# names      : sentinel.1, sentinel.2, sentinel.3, sentinel.4 
# min values :          0,          0,          0,          0 
# max values :        255,        255,        255,        255 

#NIR = sentinel.1
#RED = sentinel.2

nir <- sent$sentinel.1
red <- sent$sentinel.2

ndvi <- (nir-red)/(nir+red)
plot(ndvi)

# bianco = no vegetazione
# giallo-verde = bosco

#possiamo cambiare la colour ramp palette
cl <- colorRampPalette(c('black', 'white', 'red', 'magenta', 'green'))(100)
plot(ndvi, col=cl)

#possiamo ora calcolare la deviazione standard
#la funzione si chiama focal, appartenente al pacchetto raster
#mettiamo la dimensione della moving window e il tipo di parametro statistico da calcolare
#solitamente, si considera una finestra (quindi una matrice) quadrata
#più graqnde è il numero di pixel, più lungo è il calcolo in termini temporali
#l'importante è avere una finestra con numero dispari di pixel sui lati (es. 3x3, 5x5, 7x7, 9x9...)

#proviamo prendere una matrice quadrata di 9 pixel e di considerare ogni singolo pixel su 9 
#calcoliamo la deviazione standard (sd)

ndvisd3 <- focal(ndvi, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
clsd <- colorRampPalette(c('blue', 'green', 'magenta', 'orange', 'brown', 'red', 'yellow'))(100)
plot(ndvisd3, col=clsd)

#la variabilità aumenta quando si passa da roccia nuda a parte vegetata, 
#poi ritorna molto omogenea in tutta la parte vegetata,
#abbiamo delle piccole zone con sd in aumento (crepacci, ombre)

#calcoliamo ora la media della biomassa
ndvim3 <- focal(ndvi, w=matrix(1/9, nrow=3, ncol=3), fun=mean)
plot(ndvim3, col=clsd)
#ci saranno valori molto alti nelle praterie di alta quota,
#valori alti per la parte vegetata
#valori più bassi per la roccia nuda

#proviamo a cambiare la frequenza di calcolo con una finestra di 9x9
ndvisd9 <- focal(ndvi, w=matrix(1/81, nrow=9, ncol=9), fun=sd)
plot(ndvisd9, col=clsd)

#in questo caso, potrebbe essere l'ideale avere una finestra 5x5, 3x3 è una variabilità molto locale
ndvisd5 <- focal(ndvi, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
plot(ndvisd5, col=clsd)

# Un altro modo per compattare i dati in un solo layer è di utilizzare la PCA
sentpca <- rasterPCA(sent)
plot(sentpca$map)

#la prima componente principale è quella che ha la maggior parte del range spiegato
#aumentando il numero, si perde la maggior parte dell'informaizone

sentpca #per vedere come è composta

#facciamo un summarty per vedere quanta variabilità spiegano le varie componenti
summary(sentpca$model)

#Importance of components:
#                           Comp.1     Comp.2      Comp.3 Comp.4
#Standard deviation     77.3362848 53.5145531 5.765599616      0
#Proportion of Variance  0.6736804  0.3225753 0.003744348      0
#Cumulative Proportion   0.6736804  0.9962557 1.000000000      1
 
#la prima PCA spega 67.36804% della variabilità, in proporzione è quella con la maggiore variabilità
#la seconda aggiunge il 32.25753%, per un totale del 99.62557%, è perpendicolare alla prima

pc1 <- sentpca$map$PC1

pc1sd5 <- focal(pc1, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue', 'green', 'magenta', 'orange', 'brown', 'red', 'yellow'))(100)
plot(pc1sd5, col= clsd)

#usiamo la funzione source per richiamare un pezzo di codice già scritto
source("source_test_lezione.r")

#alta variazione standard si ha in corrispondenza di alte variazioni morfologiche

source("source_ggplot.r")

ggplot() +
geom_raster(pc1sd5, mapping = aes (x=x, y=y, fill=layer))
#ggplot() così aprirebbe solo una finestra vuota. il pacchetto aggiunge dei blocchi utilizzando +
#possiamo aggiungere delle geometrie (es. punti, linee...) con geom_point o geo_line... 
#per geom_raster richiede come argomento mapping, inerente alle aestetics (x e y del grafico, come valore di riempimento ci mettiamo il layer)

#se cerchiamo su internet come funziona il pacchetto, ci sono anche i nomi delle palette di colori!
# https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
#la funzione per poterle utilizzare si chiama scale_fill_viridis()

ggplot() +
geom_raster(pc1sd5, mapping = aes (x=x, y=y, fill=layer)) +
scale_fill_viridis() #di default, c'è la palette viridis

#per cambiare il titolo: ggtitle("Standard deviation of PC1 by viridis colour scale")

P1 <- ggplot() +
geom_raster(pc1sd5, mapping = aes (x=x, y=y, fill=layer)) +
scale_fill_viridis() +
ggtitle("Standard deviation of PC1 by viridis colour scale")

#proviamo con la palette magma
P2 <- ggplot() +
geom_raster(pc1sd5, mapping = aes (x=x, y=y, fill=layer)) +
scale_fill_viridis (option = "magma") +
ggtitle("Standard deviation of PC1 by magma colour scale")

#con turbo
P3 <- ggplot() +
geom_raster(pc1sd5, mapping = aes (x=x, y=y, fill=layer)) +
scale_fill_viridis (option = "turbo") +
ggtitle("Standard deviation of PC1 by turbo colour scale") # è la rainbow
#per una questione visiva, meglio utilizzare le prime due

#posso mettere insieme questi grafici grazie al pacchetto gridExtra
grid.arrange(P1,P2,P3, ncol=3)


