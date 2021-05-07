#R_code_land_cover.r

library(raster)
library(RStoolbox)
#install.packages("ggplot2")
library(ggplot2)
#install.packages("gridExtra")
library(gridExtra)

setwd("C:/lab/deforestazione")


defor1 <- brick("defor1.jpg") #1992
defor2 <- brick("defor2.jpg") #2006

#per confrontarle
par(mfrow=c(1,2))
plotRGB(defor1, 1, 2, 3, stretch="Lin")
plotRGB(defor2, 1, 2, 3, stretch="Lin")

# ggRGB ha bisogno dell'immagine da plottare, delle bande montate r, g, b, e lo stretch
ggRGB(defor1, 1, 2, 3, stretch="Lin") #plotta l'immagine con gli assi cartesiani
ggRGB(defor2, 1, 2, 3, stretch="Lin")
#negli assi sono riportati i pixel, non sono coordinate geografiche

#per confrontare i due ggRGB non è possibile utilizzare il par. ci vuole una funzione specifica
p1 <- ggRGB(defor1, 1, 2, 3, stretch="Lin")
p2 <- ggRGB(defor2, 1, 2, 3, stretch="Lin")
grid.arrange(p1, p2, nrow=2) #possiamo arrangiare qualsiasi tipo di griglia

#facciamo una classificazione di land cover:
# per semplicità, distinguiamo: foresta amazzonica e campi agricoli

#unsupervised classification
#di default, il numero di campioni presi sono 10000
#set.seed() per avere sempre gli stessi risultati
d1c <- unsuperClass(defor1, nClasses=2)
plot(d1c$map)
#Classe 1 = foresta amazzonica
#Classe 2 = terreni agricoli
d2c <- unsuperClass(defor2, nClasses=2)
plot(d2c$map)
#Classe 1 = terreni agricoli
#Classe 2 = foresta amazzonica

#proviamo con 3 classi
d2c3 <- unsuperClass(defor2, nClasses=3)
plot(d2c3$map)
#ha distinto all'interno dell'agricolo 2 classi (molto probabilmente ci sono due tipologie di piante coltivate)

#andiamo a calcolare quanta area di foresta abbiamo perso
#lo facciamo calcolando la frequenza dei pixel che appartengono ad una certa classe
#la funzione è freq() come argomento ci mettiamo la mappa che abbiamo generato
freq(d1c$map)

#  value  count
#[1,]     1 305821
#[2,]     2  35471

#facciamo la proprorzione: classe 1 /  pixel totali
s1 <- 305821 + 35471     #341292

prop1 <- freq(d1c$map) / s1
#            value     count
#[1,] 2.930042e-06 0.8960685
#[2,] 5.860085e-06 0.1039315

#nel 1992, la foresta amazzonica è l'89,6% del totale, solo il 10,4% è occupata dai terreni agricoli


freq(d2c$map)
#     value  count
#[1,]     1 163903
#[2,]     2 178823
s2 <- 342726
prop2 <- freq(d2c$map) / s2
#            value     count
#[1,] 2.917783e-06 0.4782333 (agricolo)
#[2,] 5.835565e-06 0.5217667 (foresta)

#nel 2006, la foresta occupava il 52,2% del territorio, mentre l'agricolo il 47,8%!

#generiamo un data frame --> dataset composto da:

# una prima colonna con dei fattori (cover) = variabili categoriche (terreni agricoli e foresta amazzonica)
#seconda colonna: percentuale del 1992 (percent_1992)
#terza colonna: percentuale del 2006 (percent_2006)

# |Cover        | percent_1992 | percent_2006|
# |Forest       |              |             |
# |Agriculture  |              |             |

cover <- c("Forest","Agriculture") #fra virgolette perché è una stringa, mettiamo c perché è un vettore
percent_1992 <- c(89.6, 10.4)
percent_2006 <- c(52.2, 47.8)

#a questo punto ci creiamo il data frame con la funzione data.frame()
deforestazione <- data.frame(cover, percent_1992, percent_2006)

#facciamo un grafico con ggplot2
#plotta un dataset. si può lavorare sulla parte estetica (prima colonna, seconda colonna e tipo di colore)
#possiamo anche scegliere il geom.point
ggplot(deforestazione, aes(x = cover, y = percent_1992, color = cover)) + geom_bar(stat="identity", fill="white")
#vogliamo distinguere le due classi in cover
#stat = "identity" vuol dire che vogliamo usare i dati come li usiamo noi
ggplot(deforestazione, aes(x = cover, y = percent_2006, color = cover)) + geom_bar(stat="identity", fill="white")

#posssiamo montarli insieme con grid.arrange
p1 <- ggplot(deforestazione, aes(x = cover, y = percent_1992, color = cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(deforestazione, aes(x = cover, y = percent_2006, color = cover)) + geom_bar(stat="identity", fill="white")

grid.arrange(p1, p2, nrow=1)
