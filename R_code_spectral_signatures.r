# R_code_spectral_signatures.r

# se ci sono dei sensori appositi, è possibile distinguere le firme spettrali di piante/minerali.

library(raster)
library(rgdal)
library(ggplot2)

#impostare la cartella di lavoro su Windows
setwd("C:/lab/deforestazione")

#carichiamo tutte le bande con il brick
defor2 <- brick("defor2.jpg")

#NIR = defor2.1
#red = defor2.2
#green = defor2.3

plotRGB(defor2, r=1, g=2, b=3, stretch="lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="hist")

#creiamo un piccolo dataset di firme spettrali, ci serve la libreria rgdal

click(defor2, id=T, xy=T, cell=T, type="p", pch=16, col="yellow")
#Query by clicking on a map --> mi permette di cliccare direttamente su una mappa e di ottenerne le specifiche informazioni
# argomenti: 
      # nome mappa su cui vogliamo cliccare, 
      # nome identificativo ID per ogni punto, 
      # xy, per utilizzare le coordinate spaziali (T=TRUE),
      # cell perché puntiamo su un pixel
      # faremo un click di tipo puntuale, quindi punto (=p)
      # pacchetto pch --> forme disponibili in R per il punto, 16 = pallino chiuso
      # colore del simbolo (col)
# se clicco su un punto della mappa dove c'è vegetazione, ottengo una piccola "tabella":

#           x       y     cell  defor2.1 defor2.2  defor2.3    
#   1   345.5   229.5   178162       216        8        21

#mi dice che il punto (con identificativo 1) ha coordinate x=345.5, y=229.5, che si trova nella 178162 cella e le informazioni relative alla riflettanza nelle 3 bande
# si ricorda che si tratta di un'immagine a 8 bit e che quindi il valore massimo di riflettanza è di 250
# in questo caso, la banda 1 (NIR) ha un valore molto alto, la seconda (RED) basso perché viene assorbita, la terza (GREEN) un valore medio-alto.

#clicco ora su un punto del fiume
#           x       y     cell  defor2.1 defor2.2  defor2.3    
#   1   562.5   228.5   179096        39       87       125

#abbiamo una riflettanza molto più bassa per il NIR, ed una molto più alta per RED e GREEN


#creiamo ora un dataset:
# banda    e   tipo di uso del suolo (classe di landcover a terra), quindi Foresta (F) e acqua (W)

#definiamo le colonne del dataset
band <- c(1,2,3)
forest <- c(216, 8, 21)  #valore di riflettanza della foresta
water <- c(39, 87, 125)  #valore di riflettanza dell'acqua del fiume

#adesso le mettiamo insieme, creando il dataframe
spectralS <- data.frame(band, forest, water)

#adesso andiamo ad utilizzare il pacchetto ggplot2 per plottare le firme spettrali
ggplot(spectralS, aes(x=band))+
      geom_line(aes(y=forest), color= "green")+ 
      geom_line(aes(y=water), color= "blue")+
      labs(x="wavelength", y="reflectance") 
  #argomenti: 
            # dataset
            # asse x = bande
            # asse y le varie spectral signatures che abbiamo, quindi la riflettanza
       # (per definire gli assi usiamo aes), mentre per inserire le geometrie usiamo geom_line (line perché vogliamo una linea)


#####################################################################################################

#possiamo fare più signatures e farci un'analisi di varianza. posso anche classificare i pixel con riflettanza simile come con la classificazione di immagine
# andiamo a farlo con un'analisi multitemporale

defor1 <- brick("defor1.jpg")
plotRGB(defor1, r=1, g=2, b=3, stretch="lin")
click(defor1, id=T, xy=T, cell=T, type="p", pch=16, col="yellow")
#spectral signatures defor1
# prendo 5 punti dove vedo che nel tempo la zona è stata deforestata

#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 38.5 316.5 114993      214       23       38
#     x     y   cell defor1.1 defor1.2 defor1.3
#1 57.5 329.5 105730      216       20       34
#     x     y  cell defor1.1 defor1.2 defor1.3
#1 88.5 374.5 73631      209        8       26
#     x     y  cell defor1.1 defor1.2 defor1.3
#1 66.5 407.5 50047      219       36       56
#     x     y  cell defor1.1 defor1.2 defor1.3
#1 42.5 401.5 54307      230       23       51

#faccio lo stesso con defor2
#     x     y   cell defor2.1 defor2.2 defor2.3
#1 39.5 333.5 103288      250      168      174
#     x     y  cell defor2.1 defor2.2 defor2.3
#1 39.5 354.5 88231      130      113       97
#     x     y  cell defor2.1 defor2.2 defor2.3
#1 70.5 360.5 83960      164      162      147
#     x     y  cell defor2.1 defor2.2 defor2.3
#1 58.5 384.5 66740      189      144      139
#     x     y  cell defor2.1 defor2.2 defor2.3
#1 57.5 367.5 78928      140      110      108


#definiamo le colonne del dataset
band <- c(1,2,3)
time1 <- c(214,23,38)
time2 <- c(250,168,174)

spectralsT <- data.frame (band,time1,time2)

ggplot(spectralsT, aes(x=band))+
      geom_line(aes(y=time1), color= "red")+ 
      geom_line(aes(y=time2), color= "gray")+
      labs(x="wavelength", y="reflectance") 

#metto anche gli altri pixxel

band <- c(1,2,3)
time1p1 <- c(214,23,38)
time1p2 <- c(216,20,34)
time1p3 <- c(209,8,26)
time1p4 <- c(219,36,56)
time1p5 <- c(230,23,51)
time2p1 <- c(250,168,174)
time2p2 <- c(130,113,97)
time2p3 <- c(164,162,147)
time2p4 <- c(189,144,139)
time2p5 <- c(140,110,108)
spectralsT2 <- data.frame (band,time1p1,time1p2,time1p3,time1p4,time1p5,time2p1,time2p2,time2p3,time2p4,time2p5)

ggplot(spectralsT2, aes(x=band))+
      geom_line(aes(y=time1p1), color= "red")+ 
      geom_line(aes(y=time1p2), color= "orange")+ 
      geom_line(aes(y=time2p1), color= "lightgray")+
      geom_line(aes(y=time2p2), color= "gray")+
      labs(x="wavelength", y="reflectance") 


# per eseguire un'analisi vera è consigliabile utilizzare una funzione che genera punti random (random.point o extract)
# quando ci sono tante linee è possibile utilizzare una linea a puntini (linetype="dotted")




