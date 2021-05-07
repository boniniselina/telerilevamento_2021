#ANALISI MINERALOGICA/PETROGRAFICA DELL'AREA A SUD-EST DI CUSCO, PERU'

#scaricare il pacchetto "raster" e permettere al programma di utilizzarlo con la fubnzione library(raster)
library(raster)
#scaricare anche il pacchetto "rasterVis"
library(rasterVis)

#impostare la cartella di lavoro
setwd("C:/esame")

#caricare i dati sentinel creando dapprima una lista, applicando a tutti la stessa funzione (raster) con il comando lapply e prepararle con la funzione stack 
rlist <- list.files(pattern="10m")
import <- lapply(rlist, raster)
peru <- stack(import) 

#organizzo le bande
#blu = T19LBE_20//21_B02_10m
#verde = T19LBE_20//21_B03_10m
#rosso = T19LBE_20//21_B04_10m
#infrarosso = T19LBE_20//21_B08_10m
#colori = T19LBE_20//21_TCI_10m

#plotto tutti i livelli 
levelplot(peru)

#posso fare lo stesso con una palette appositamente creata, non ha molto senso
#cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
#levelplot(TGr,col.regions=cl)

#plotto le immagini con la funzione plotRGB per avere la possibilità di montare le bande a piacimento
#posso plottarle tutte insieme grazie alla funzione par

par(mfrow=c(3,2))
plotRGB(peru,4,3,2, stretch="Lin") #colori normali
plotRGB(peru,2,3,4, stretch="Lin") #tono del blu
plotRGB(peru,3,4,2, stretch="Lin") #tono del verde
plotRGB(peru,4,2,3, stretch="Lin") #tono del rosso
plotRGB(peru,8,3,2, stretch="Lin") #infrarosso

#andiamo ora a fare la classificazione di immagine 

#prima di tutto bisogna richiamare il paccketto RStoolbox, poiché andremo ad utilizzare una funzione in esso contenuta
library(RStoolbox)

#utilizziamo un comando per usare solo dei pixel specifici come campione per costruire il training set
set.seed(1000)
#UNSUPERVISED CLASSIFICATION --> usa una forma randomizzata per la scelta dei pixel
#la funzione che useremo è unsuperClass
#bisogna dare come argomento: il nome dell'immagine, quanti pixel da utilizzare come training set (nSamples), il numero di classi (nClasses) 

# facciamo delle prove con diversi numeri di classi

#con 10 classi:
peru1c <- unsuperClass(peru, nClasses=10)

plot(peru1c$map)


