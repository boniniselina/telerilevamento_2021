# R_code_exam.r

#Analisi della variazione mineralogica/petrografica della Rainbow Mountain (originariamente conosciuta come Vinicunca), 
#una bellissima attrazione naturale situata nelle Ande peruviane, qualche km a SE della città di Cuzco.
#Mineral/Petrographic variation analysis of the Rainbow Mountain (Vinicunca), 
#one of the most important (and beautiful, as well) natural attractions located on the Andes mountains of Peru. 

#Pacchetti utili:
#Used Packages: 

#scaricare il pacchetto "raster" e permettere al programma di utilizzarlo con la funzione library(raster)
library(raster)
#il pacchetto RStoolbox, poiché andremo ad utilizzare una funzione in esso contenuta per fare la classificazione di immagine
library(RStoolbox)
#usufruisco anche dei pacchetti rgdal e ggplot 
library(rgdal)
library(ggplot2)


#Settare la cartella di lavoro (chiamata "esame", che io creato in C:)
#Set working directory (mine is called "esame" and has been created in C:) 
setwd("C:/esame/") #for Windows

# Ho scaricato i dati originali sentinel di quella porzione delle Ande grazie all'Open Hub del sito Copernucus, relative al giorno 5 novembre 2020
# https://scihub.copernicus.eu/dhus/#/home
# delle varie immagini che compongono il set, ho scelto quelle con risoluzione maggiore (10x10m)
# ho preso l'immagine "T19LBE_20201105T145731_TCI_10m.jp2", la quale ha già le bande montate (r=red, g=green, b=blue), 
# e l'ho ingrandita, arrivando ad una scala di 1:25000, in modo da avere una migliore visualizzazione dell'area. ho salvato l'immagine con il nome "peru_25000.png".
# After downloading original Sentinel data from Copernicus site web (https://scihub.copernicus.eu/dhus/#/home), dating 5th of November 2020
# I modified the image characterized by already-set bands (r=red, g=green, b=blue) to retail the studied area with a scale 1:25000, which I call "peru_25000.png".

peru <- brick("peru_25000.png")

#per visualizzarla, essendo già di default le bande posizionate in questo modo, è possibile utilizzare la funzione plotRGB() senza altri argomenti specificati
#plotRGB(peru)
#utilizzando uno stretch lineare, i colori vengono "tirati", "stretchati". si ottiene un effetto molto colorato
#plotRGB(peru, stretch="Lin")
#possiamo metterli a confronto grazie alla fuzione par(), specificando il numero di righe e colonne su cui vogliamo vengano visualizzati i plot
#As the image has the bands already set in order, I can visualize it using plotRGB() function. With a linear stretch, I can obtain a very-colorful effect.
#I can compare these images visualizing them on the same plot window (using par() function).

par(mfrow=c(1,2))
plotRGB(peru)
plotRGB(peru, stretch="Lin")

#posso caricare anche il set di singole bande (anch'esse ritagliate in modo che si visualizzi la stessa area)
#I can stack the single bands 
rlist <- list.files(pattern="banda")
import <- lapply(rlist, raster)
perub <- stack(import) 

#in questo modo posso montare le bande a piacimento
#So I can organize bands as I want
#blu (blue) = T19LBE_20//21_B02_10m --> peru_banda_blu.png
#verde (green) = T19LBE_20//21_B03_10m --> peru_banda_green.png
#rosso (red) = T19LBE_20//21_B04_10m --> peru_banda_red.png
#vicino infrarosso (NIR) = T19LBE_20//21_B08_10m --> peru_banda_NIR.png

#Classificazione di immagine
#Image Classification

#UNSUPERVISED CLASSIFICATION --> usa una forma randomizzata per la scelta dei pixel
#la funzione che useremo è unsuperClass
#bisogna dare come argomento: il nome dell'immagine, quanti pixel da utilizzare come training set (nSamples), il numero di classi (nClasses)
#I use unsuperClass, function which operates a rondomized choice for pixel and needs ad arguments: name of image, number of pixels to use like training set and number of classes


#con 5 classi:
#Analisys with 5 classes:
peru1c <- unsuperClass(peru, nClasses=5)
#per visualizzare la mappa, essendo uno degli elementi creati con unsuperClass, è necessario legarla al nome con il simbolo $
#the just-created map is an element, for this reason I have to link it with the variable name using $ symbol

#ho creato una palette di colori 
#I create a color palette
cl2 <- colorRampPalette(c('brown', 'pink3', 'steelblue3', 'seagreen1', 'white'))(100)

plot(peru1c$map, col=cl2)
#CLASSE 5 = Vegetation and phyllites and clays rich in ferro magnesian, 
#CLASSE 4 = Fanglomerate composed of rock with magnesium, 
#CLASSE 3 = Calcareous sandstones rich in sulphurous minerals, 
#CLASSE 2 = Red clay, fangolitas (mud) and arilitas (sand), 
#CLASSE 1 = Claystones rich in iron oxides

#Per verificare l'effettiva presenza della vegetazione, ho fatto ricorso all'indice di vegetazione normalizzato
#To verify the presence of vegetation I calculate the normalized vegetation index.
#NDVI = (NIR-Red)/(NIR+Red)
NIR <- perub$peru_banda_NIR
red <- perub$peru_banda_red
ndvi <- (NIR-red)/(NIR+red)
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(ndvi, col=cl)



# --------------------------------------------------------------------------------------------------------------------------------------------------


#Faccio lo stesso procedimento con la seconda area di studio: Las Montañas de 14 Colores, situate nella porzione Nord-Occidentale dell'Argentina
#essendo un'area più vasta rispetto a Vinicunca, la scala della mappa è stata riportata a 1:50.000. L'immagine è datata al 02/04/2021.
#The same procedure was performed for the second study area: Las Montañas de 14 Colores, situated on north-western part of Argentine. As the area is much larger then Vinicunca, I choose a larger scale (1:50.000).
#the image is dated on the 2nd of April 2021.

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

#con la palette voglio associare ai membri della formazione gli stessi colori della palette che ho associato all'area in Perù:
#marrone --> argilliti ricche in ossidi di ferro
#rosa --> argille rosse, fangolitas e ariitas ricche di manganese
#blu --> arenarie calcaree ricche in minerali di zolfo
#verde acqua --> fanglomerato
#bianco --> vegetazione e filliti

#I try to associate the Palette colors to the same members, as I did for Perù.
#brown ---> Claystones rich in iron oxides
#pink ---> Red clay, fangolitas (mud) and arilitas (sand)
#blue ---> Calcareous sandstones rich in sulphurous minerals
#seagreen ---> Fanglomerate composed of rock with magnesium
#white ---> Vegetation and phyllites 


#Vegetation Index
NIRa <- argb$argentina_banda_NIR
reda <- agrb$argentina_banda_red
ndvia <- (NIRa-reda)/(NIRa+reda)
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(ndvia, col=cl)

# ------------------------------------------------------------------------------------------------------------------------

#creo un dataset con le firme spettrali delle varie componenti classificate della formazione di Yacoraite
# prima di tutto mi scelgo i punti di cui voglio conoscere la riflettanza grazie al comando click.
#ho bisogno del pacchetto rgdal
#I compose a dataset with spectral signatures of Yacoraite formation members
#I just have to choose pixels which I want to know the reflectance of. I need to use rgdal package

click(peru, id=T, xy=T, cell=T, type="p", pch=16, col="yellow")
#Query by licking on a map --> mi permette di cliccare direttamente su una mappa e di ottenerne le specifiche informazioni
# argomenti/arguments: 
      # nome mappa su cui vogliamo cliccare, / name of map
      # nome identificativo ID per ogni punto, / identity name for each point
      # xy, per utilizzare le coordinate spaziali (T=TRUE), / xy if I want to use spatial coordinates
      # cell perché puntiamo su un pixel / cell because I click a pixel
      # faremo un click di tipo puntuale, quindi punto (=p) / p, because a click match a point
      # pacchetto pch --> forme disponibili in R per il punto, 16 = pallino chiuso / pch package tell us available shapes for the symbol
      # colore del simbolo (col) / color of the symbol
# se clicco su un punto della mappa ottengo una piccola "tabella". Lo faccio per 5 punti, uno per ogni classe. Ottengo come risultato:
# if I click on the map I obtain a "table". I do it fo 5 times, one for each class. Results:


#       x      y     cell peru_25000.1 peru_25000.2 peru_25000.3 peru_25000.4
#1 2865.5 3102.5 60380354          158           67           44          255 #Classe1
#       x      y     cell peru_25000.1 peru_25000.2 peru_25000.3 peru_25000.4 
#1 3396.5 1041.5 84478097          170          121           95          255 #Classe2
#       x      y     cell peru_25000.1 peru_25000.2 peru_25000.3 peru_25000.4
#1 6227.5 3959.5 50363672          238          188          133          255 #Classe3
#        x      y     cell peru_25000.1 peru_25000.2 peru_25000.3 peru_25000.4
#1 11464.5 1041.5 84486165          115           91           65          255 #Classe4 
#       x      y     cell peru_25000.1 peru_25000.2 peru_25000.3 peru_25000.4
#1 8616.5 5219.5 35634141           54           46           17          255 #Classe5


#creiamo ora un dataset, definendo prima le colonne:
#define the columns
band <- c(1,2,3)
red_ironoxides <- c(158, 67, 44)
rose_redclays_fangolitas <- c(170, 121, 95)
yellow_solfur <- c(238, 188, 133)
brown_fanglomerate <- c(115, 91, 65)
green_phyllites <- c(54, 46, 17)

#adesso le mettiamo insieme, creando il dataframe
#create the dataframe
spectrals <- data.frame(band, red_ironoxides, rose_redclays_fangolitas, yellow_solfur, brown_fanglomerate, green_phyllites)

#risultato:
#results:
#  band red_ironoxides rose_redclays_fangolitas yellow_solfur brown_fanglomerate
#1    1            158                      170           238                115
#2    2             67                      121           188                 91
#3    3             44                       95           133                 65
#  green_phyllites
#1              54
#2              46
#3              17

#adesso andiamo ad utilizzare il pacchetto ggplot2 per plottare le firme spettrali
#use ggplot2 to plot the spectral signatures
ggplot(spectrals, aes(x=band))+
      geom_line(aes(y=red_ironoxides), color= "red")+ 
      geom_line(aes(y=rose_redclays_fangolitas), color= "pink")+
      geom_line(aes(y=yellow_solfur), color= "darkgoldenrod1")+
      geom_line(aes(y=brown_fanglomerate), color= "brown")+
      geom_line(aes(y=green_phyllites), color= "green")+
      labs(x="wavelength", y="reflectance") 
  #argomenti/arguments: 
            # dataset
            # asse x = bande / bands
            # asse y le varie spectral signatures che abbiamo, quindi la riflettanza /reflectance
       # (per definire gli assi usiamo aes), mentre per inserire le geometrie usiamo geom_line (line perché vogliamo una linea)
