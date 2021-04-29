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
#banda del blu e del verde sono molto correlate, indice di Prinson R= 0.93

#Creiamo la PCA
#ricampioniamo il dato per renderlo più leggero con la funzione aggregate.
#la risoluzione dell'immagine è 30x30m
#li possiamo aggregare, ad esempio, di un fattore 10, assumendo come valore il valore medio di quei 10x10 pixel raggruppati

#RESAMPLING (ricampionamento)
p224r63_2011res <- aggregate(p224r63_2011, fact=10) #nome immagine, fattore, nome della funzione da utilizzare
#a questo punto, abbiamo un'immagine che ha una risoluzione di 300x300m, abbiamo diminuito linearmente di un fattore 10
#aumentare la grandezza del pixel vuol dire anche averne 10 volte in meno rispetto al numero di partenza

#confrontiamo le due immagini
par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011res, r=4, g=3, b=2, stretch="Lin")

#PCA
#Principal Component Analysis per i Raster
#compattiamo in un minor numero di bande
#riduciamo da 2 dimensioni ad una sola, prendendo la PC1 (90% della varianza)
#la funzione è rasterPCA

p224r63_2011res_pca <- rasterPCA(p224r63_2011res)
#prendiamo l'immagine originale (meglio se aggregata), ci facciamo la PCA e adesso andiamo a vedere i prodotti ottenuti
#contiene al suo interno la mappa, il modello, ecc.

#usiamo la funzione summary --> funzione generica che ci dà il sommario del nostro modello
summary(p224r63_2011res_pca$model)

#cosa ci dice il risultato:
#Importance of components:
#                         Comp.1      Comp.2
#Standard deviation     1.2050671 0.046154880
#Proportion of Variance 0.9983595 0.001464535           #solo con la prima componente, la PC1 è in grado di spiegare il 99% della varianza!
#Cumulative Proportion  0.9983595 0.999824022           #la seconda aggiunge solo uno 0.1464535% di informazione in più, per un totale di 99.9824022%
#                             Comp.3       Comp.4
#Standard deviation     0.0151509526 4.575220e-03
#Proportion of Variance 0.0001578136 1.439092e-05
#Cumulative Proportion  0.9999818357 9.999962e-01      #con le prime 3 bande spiego il 99,99818357%
#                             Comp.5       Comp.6
#Standard deviation     1.841357e-03 1.233375e-03
#Proportion of Variance 2.330990e-06 1.045814e-06
#Cumulative Proportion  9.999986e-01 9.999996e-01
#                             Comp.7
#Standard deviation     7.595368e-04
#Proportion of Variance 3.966086e-07
#Cumulative Proportion  1.000000e+00          

#vediamolo in grafico, facendo il plot 
plot(p224r63_2011res_pca$map) 
#la prima componente PC1 ha praticamente tutta l'informazione, mentre l'ultima è solo rumore

#informazioni sull'immagine p224r63_2011res_pca:
p224r63_2011res_pca
#la mappa è un rasterbrick con la dimensione uguale a quella originale, e le varie componenti (da 1 a 7).

#facciamo un plotRGB con le prime 3 componenti principali.
plotRGB(p224r63_2011res_pca$map, r=1, g=2, b=3, stretch="Lin")



