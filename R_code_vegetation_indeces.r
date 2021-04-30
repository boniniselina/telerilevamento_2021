#R_code_vegetation_indeces.r

#ci troviamo presso Rio Peixoto de Azevedo, in Brasile
#andiamo ad analizzare la deforestazione a discapito della foresta pluviale attraverso gli indici di vegetazione
#sono immagini già processate
#la banda dell'infrarosso è stata montata sulla componente red, per cui la vegetazione ha uno spiccato colore rosso
#abbiamo al confronto 2 immagini della stessa area: una pre- ed una post- intervento umano 

library(raster)
library(RStoolbox)

setwd("C:/lab/deforestazione")

defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")

#in questo caso:
# 1 = banda dell'infrarosso (NIR)
# 2 = banda del rosso (RED)
# 3 = banda del verde (GREEN)

par(mfrow=c(2,1))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")
#vediamo la multitemporalità della zona
#acqua chiara = molto trasporto solido, perché l'acqua pura assorbe l'infrarosso e verrebbe di oclore scuro (tendente al blu o nero)

#installare il pacchetto
install.packages("rasterdiv")

#DVI
#DIV = NIR-RED

#nella defor1:
#nomi delle bande
#defor1.1 = NIR
#defor1.2 = RED
#defor1.3 = GREEN

#siamo ad 8 bit (2^8 = 256) ----> valore massimo si avrà con NIR= 255 e RED = 0, mentre il valore minimo NIR=0 e RED=255
#DIV varierà fra i due valori -255 e 255

dvi1 <- defor1$defor1.1 - defor1$defor1.2

#mettiamo una palette di colori per visualizzare al meglio la mappa
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) 
#rosso scuro = vegetazione
#giallo = terreni agricoli
plot(dvi1, col = cl, main = "DVI at time 1")

#nella defor.2:
dvi2 <- defor2$defor2.1 - defor2$defor2.2
plot(dvi2, col = cl, main = "DVI at time 2")

#per confrontarle:
par(mfrow=c(2,1))
plot(dvi1, col = cl, main = "DVI at time 1")
plot(dvi2, col = cl, main = "DVI at time 2")

#vediamo quanto la situazione è cambiata:
difdvi <- dvi1-dvi2 #anche se le due immagini hanno estensioni leggermnete diverse, calcolerà la differenza nei pixel comuni (all'intersezione)
#usiamo un'altra palette per esaltare il risultato
cld <- colorRampPalette(c('blue','white','red'))(100)
plot(difdvi, col=cld, main="Differenza fra i due DVI")

#NDVI
#indice normalizzato per la somma
#NDVI = NIR - RED / NIR + RED
#utile per quando si cambia immagine e questa ha un'altra dimensione (es. 16 bit = 65535), in questo caso si avrà un valore compreso fra -65535 e +65535
#non sarebbero comparabili
#il NDVI avrà sempre lo stesso range (-1 < NDVI < 1)

ndvi1 = dvi1 / (defor1$defor1.1 + defor1$defor1.2) #dove dvi1=defor1$defor1.1 - defor1$defor1.2
ndvi2 = dvi2 / (defor2$defor2.1 + defor2$defor2.2)

par(mfrow=c(2,1))
plot(ndvi1, col = cl, main = "NDVI at time 1")
plot(ndvi2, col = cl, main = "NDVI at time 2")

difndvi = ndvi1 - ndvi2
plot(difndvi, col=cld)

#c'è una funzione nel pacchetto RStoolbox che permette di calcoolare gli indici spettrali
#dobbiamo dichiarare le bande, possiamo usare i colori: green = 3, rosso = 2, nir = 1
#calcola tutti gli indici che non hanno bisogno della banda del blu (che nel nostro caso non c'è)
vi1 <- spectralIndices(defor1, green = 3, red = 2, nir = 1)
plot(vi1, col=cl)

vi2 <- spectralIndices(defor2, green = 3, red = 2, nir = 1)
plot(vi2, col=cl)

