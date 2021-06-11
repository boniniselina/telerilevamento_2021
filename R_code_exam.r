# R_code_exam.r

#Analisi della variazione mineralogica/petrografica della Rainbow Mountain (originariamente conosciuta come Vinicunca), 
#una bellissima attrazione naturale situata nelle Ande peruviane, qualche km a SE della città di Cuzco.
#Mineral/Petrographic variation analysis of the Rainbow Mountain (Vinicunca), 
#one of the most important (and beautiful, as well) natural attractions located on the Andes mountains of Peru. 

#Pacchetti utili:
#Used Packages: 

#scaricare il pacchetto "raster" e permettere al programma di utilizzarlo con la funzione library(raster)
library(raster)
#scaricare anche il pacchetto "rasterVis" 
library(rasterVis)
#ed il pacchetto RStoolbox, poiché andremo ad utilizzare una funzione in esso contenuta per fare la classificazione di immagine
library(RStoolbox)

#possono essere utili anche 
#library(ggplot2)
#library(gridExtra)
#library(viridis)

#Settare la cartella di lavoro (chiamata "esame", che io creato in C:)
#Set working directory (mine is called "esame" and has been created in C:) 
setwd("C:/esame/") #for Windows

# Ho scaricato i dati originali sentinel di quella porzione delle Ande grazie all'Open Hub del sito Copernucus, relative al giorno 5 novembre 2020
# https://scihub.copernicus.eu/dhus/#/home
# delle varie immagini che compongono il set, ho scelto quelle con risoluzione maggiore (10x10m)
# ho preso l'immagine "T19LBE_20201105T145731_TCI_10m.jp2", la quale ha già le bande montate (r=red, g=green, b=blue), 
# e l'ho ingrandita, arrivando ad una scala di 1:25000, in modo da avere una migliore visualizzazione dell'area. ho salvato l'immagine con il nome "peru_25000.png".
# After downloading original Sentinel data from Copernicus site web (https://scihub.copernicus.eu/dhus/#/home), dating 5th of November 2020
# I modified the image characterized by already setted bands (r=red, g=green, b=blue), to retail the studied area with a scale 1:25000, which I call "peru_25000.png".

peru <- brick("peru_25000.png")

#per visualizzarla, essendo già di default le bande posizionate in questo modo è possibile utilizzare la funzione plotRGB() senza altri argomenti specificati
#plotRGB(peru)
#utilizzando uno stretch lineare, i colori vengono "tirati", "stretchati". si ottiene un effetto molto colorato
#plotRGB(peru, stretch="Lin")
#possiamo metterli a confronto grazie alla fuzione par(), specificando il numero di righe e colonne su cui vogliamo vengano visualizzati i plot
par(mfrow=c(1,2))
plotRGB(peru)
plotRGB(peru, stretch="Lin")

#posso caricare anche il set di singole bande (anch'esse ritagliate in modo che si visualizzi la stessa area)
rlist <- list.files(pattern="banda")
import <- lapply(rlist, raster)
perub <- stack(import) 

#in questo modo posso montare le bande a piacimento
#blu = T19LBE_20//21_B02_10m --> peru_banda_blu.png
#verde = T19LBE_20//21_B03_10m --> peru_banda_green.png
#rosso = T19LBE_20//21_B04_10m --> peru_banda_red.png
#infrarosso = T19LBE_20//21_B08_10m --> peru_banda_NIR.png

#Classificazione di immagine
#UNSUPERVISED CLASSIFICATION --> usa una forma randomizzata per la scelta dei pixel
#la funzione che useremo è unsuperClass
#bisogna dare come argomento: il nome dell'immagine, quanti pixel da utilizzare come training set (nSamples), il numero di classi (nClasses) 

# facciamo delle prove con diversi numeri di classi

#con 5 classi:
peru1c <- unsuperClass(peru, nClasses=5)
#per visualizzare la mappa, essendo uno degli elementi creati con unsuperClass, è necessario legarla al nome con il simbolo $
#ho creato una palette di colori 
cl2 <- colorRampPalette(c('brown', 'pink3', 'steelblue3', 'seagreen1', 'white'))(100)

plot(peru1c$map, col=cl2)
#CLASSE 5 = Vegetation and phyllites and clays rich in ferro magnesian, 
#CLASSE 4 = Fanglomerate composed of rock with magnesium, 
#CLASSE 3 = Calcareous sandstones rich in sulphurous minerals, 
#CLASSE 2 = Red clay, fangolitas (mud) and arilitas (sand), 
#CLASSE 1 = Claystones rich in iron oxides

#Per verificare l'effettiva presenza della vegetazione, ho fatto ricorso all'indice di vegetazione normalizzato
#NDVI = (NIR-Red)/(NIR+Red)
NIR <- perub$peru_banda_NIR
red <- perub$peru_banda_red
ndvi <- (NIR-red)/(NIR+red)
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(ndvi, col=cl)



# Provo a fare un'analisi della variabilità.
# Utilizzo la funzione aggregate per rendere l'immagine più leggera
peru_res <- aggregate(peru, fact=10)
#a questo punto, abbiamo un'immagine che ha una risoluzione di 100x100m, abbiamo diminuito linearmente di un fattore 10
#aumentare la grandezza del pixel vuol dire anche averne 10 volte in meno rispetto al numero di partenza

#confrontiamo le due immagini
par(mfrow=c(2,1))
plotRGB(peru, stretch="Lin")
plotRGB(peru_res, stretch="Lin")

#PCA
#Principal Component Analysis per i Raster
#compattiamo in un minor numero di bande
#riduciamo da 2 dimensioni ad una sola, prendendo la PC1 (90% della varianza)
#la funzione è rasterPCA

peru_pca <- rasterPCA(peru_res)

#vediamolo in grafico, facendo il plot 
plot(peru_pca$map) 
peru_pca$model

pc1 <- peru_pca$map$PC1

pc1sd5 <- focal(pc1, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue', 'green', 'magenta', 'brown', 'red', 'orange', 'yellow'))(100)
plot(pc1sd5, col= clsd)

ggplot() +
geom_raster(pc1sd5, mapping = aes (x=x, y=y, fill=layer)) +
scale_fill_viridis() #di default, c'è la palette viridis





#Faccio lo stesso procedimento con la seconda area di studio: Las Montañas de 14 Colores, situate nella porzione Nord-Occidentale dell'Argentina
#essendo un'area più vasta rispetto a Vinicunca, la scala della mappa è stata riportata a 1:50.000. L'immagine è datata al 02/04/2021.

argentina <- brick("arg_50000.png")
par(mfrow=c(1,2))
plotRGB(argentina)
plotRGB(argentina, stretch="Lin")

rlist <- list.files(pattern="argentina")
import1 <- lapply(rlist, raster)
argb <- stack(import1) 

# plotRGB(argb, r=4, g=3, b=2, stretch="Lin") #NIR, red, green
# plotRGB(argb, r=4, g=3, b=1, stretch="Lin") #NIr, red, blue

arg1c <- unsuperClass(argentina, nClasses=5)
cl1 <- colorRampPalette(c('white', 'brown', 'seagreen1', 'pink3', 'steelblue3'))(100)
plot(arg1c$map, col=cl1)

#CLASSE 5 = Calcareous sandstones rich in sulphurous minerals, 
#CLASSE 4 = Red clay, fangolitas (mud) and arilitas (sand), 
#CLASSE 3 = Fanglomerate composed of rock with magnesium, 
#CLASSE 2 = Claystones rich in iron oxides, 
#CLASSE 1 = Vegetation and phyllites and clays rich in ferro magnesian

#con la palette voglio associare alle fomazioni gli stessi colori che ho associato all'area in Perù:
#marrone --> argilliti ricche in ossidi di ferro
#rosa --> argille rosse, fangolitas e ariitas ricche di manganese
#blu --> arenarie calcaree ricche in minerali di zolfo
#verde acqua --> fanglomerato
#bianco --> vegetazione e filliti

NIRa <- argb$argentina_banda_NIR
reda <- agrb$argentina_banda_red
ndvia <- (NIRa-reda)/(NIRa+reda)
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(ndvia, col=cl)
