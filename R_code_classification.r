# R_code_classification.r

#andremo a fare la classificazione di immagine utilizzando le immagini scattate, e poi processate, da Solar-Orbiter

#settare la cartella di lavoro (su Windows)
setwd("C:/lab/solar_orbiter")

#l'immagine rappresenta attraverso raggi ultravioletti diversi livelli energetici che troviamo sulla superficie del Sole
#carichiamo l'immagine 
#è già caricata come un'immagine RGB, ma i tre livelli non sono quelli originali (perché processati, sono stati montati in modo da ottenere questo effetto)
#per far funzionare la funzione brick bisogna prima di tutto chiamare il pacchetto raster

library(raster)
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

#per visualizzare i dati, basta chiamare la variabile con cui l'abbiamo salvata
so
#pixel --> 2^8 valori 

#facciamo il plot per visualizzare i livelli RGB montati
plotRGB(so, 1,2,3, stretch="lin")
plotRGB(so, 1,2,3, stretch="hist")

---------------------------------------------------------------------------------------------------
#Classificazione dell'immagine
#all'interno dell'immagine, possiamo suddividere pixel con valori simili in classi
#prendo le bande come se fossero degli assi e vado a vedere i valori dei singoli pixel
#(es. distinzione fra vegetazione - basso blu, basso rosso e alto verde - e acqua - alto blu, altino verde e basso rosso)

#il software capisce come si comportano i vari pixel in uno spazio multispettrale
#a questo punto creerà delle classi sulla base di alcuni pixel presi come campione.
#questi possono essere associati ad un'etichetta
#tutti gli altri pixel saranno classificati in funzione di questo training set che si è creato, andando a valutare la distanza dei valori da quelli della nuvola di campioni
#(MAXIMUM LIKELYHOOD)
#l'unica cosa che possiamo spiegare al software è il numero di classi
---------------------------------------------------------------------------------------------------

#andremo ad usare una funzione di RStoolbox
library(RStoolbox)

#il training set li tira fuori il software (classificazione non supervisionata)
# UNSUPERVISED CLASSIFICATION --> usa una forma randomizzata per la scelta dei pixel

#la funzione che useremo è unsuperClass
#bisogna dirgli il nome dell'immagine, quanti pixel da utilizzare come training set (nSamples), il numero di classi (nClasses) (nel nostro caso 3)
#associamola ad una variabile
soc <- unsuperClass(so, nClasses=3)

#plottiamo la mappa
plot(soc$map)
#il software prende 1000 pixel random come campione, quindi ogni mappa potrebbe essere leggermente diversa dall'altra
#per questo motivo si utilizza una funzione per evitare questo problema (set.sedd)

#proviamo ad aumentare il numero di classi
socc <- unsuperClass(so, nClasses=20)
plot(socc$map)
