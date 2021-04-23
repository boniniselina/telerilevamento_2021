#R_code_multivariate_analysis.r

#Analisi Multivariata 
#informazione dei pixel molto correlata ad esempio fra due bande
#il 50% della variabilità è spiegata da una banda e l'altro 50% della variabilità, 
#i punti sono correlati da una retta

#si può compattare l'informazione. 
#passo un asse nella parte più variabile (componente principale 1, PC1)
#passo un altro asse perpendicolare ad esso (componente principale 2, PC2)
#in questo modo, nella PC1 il range di valori spiegati è il 90%, mentre nella PC2 è il rimanente 10%.
#invece di usare tutti e due gli assi, posso utilizzare ad esempio solo la PC1


library (raster)
library(RStoolbox)

#set working directory
setwd("C:/lab/lab_Brazil")

#carichiamo il dataset con la funzione brick, poiché l'immagine è composta da una serie di bande
p224r63_2011 <- brick("p224r63_2011_masked.grd")

#sono 7 bande, ognuna delle quali composta da 4447533 pixel e ha una risoluzione di 30x30m

#plottiamo i valori della banda blu (B1_sre) contro quelli della banda verde (B2_sre)
#posso plottare i punti con un colore rosso
#pch --> simboli 
plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre, col="red", pch=19, cex=2)
#darà un Warning perché il sistema prende il 2,2% dei pixel, non si mette a contare tutti i 4milioni di pixel dell'immagine

#l'informazione di un punto sulla x è molto simile all'informazione dello stesso punto sulla y

#per mettere in correlazione a 2 a 2 tutte le variabili (bande)
pairs(p224r63_2011)
#c'è un indice di correlazione di Prinson che va
# -     da 1 (positivamente correlate, dove le due variabili hanno la stessa informazione) 
# -     a -1 (negativamente correlate, dove inizia una finisce l'altra)

