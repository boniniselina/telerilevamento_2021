#R_code_vegetation_indeces.r

#ci troviamo presso Rio Peixoto de Azevedo, in Brasile
#andiamo ad analizzare la deforestazione a discapito della foresta pluviale attraverso gli indici di vegetazione
#sono immagini già processate
#la banda dell'infrarosso è stata montata sulla componente red, per cui la vegetazione ha uno spiccato colore rosso
#abbiamo al confronto 2 immagini della stessa area: una pre- ed una post- intervento umano 

library(raster)

setwd("C:/lab/deforestazione")

defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")

#in questo caso:
# 1 = banda dell'infrarosso
# 2 = banda del rosso
# 3 = banda del verde

par(mfrow=c(2,1))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")
#vediamo la multitemporalità della zona
#acqua chiara = molto trasporto solido, perché l'acqua pura assorbe l'infrarosso e verrebbe di oclore scuro (tendente al blu o nero)

#installare il pacchetto
install.packages("rasterdiv")
