# Il mio primo codice in R per  il Telerilevamento

#Imposto la working directory su Windows
setwd("C:/lab/")

#Installo il pacchetto "raster"
#install.packages("raster")
library(raster)

#carico le immagini satellitari con la funzione brick()
p224r63_2011 <- brick("p224r63_2011_masked.grd")
plot(p224r63_2011) #visualizzo le singole bande di riflettanza

#cambio il colore (scala di grigi)
cl <- colorRampPalette(c("black", "grey", "light grey")) (100)
# cambio la legenda dei colori per ogni banda
plot (p224r63_2011, col=cl)

#in scala di rosso
cls <- colorRampPalette(c("red","pink","orange","purple")) (200)
> plot(p224r63_2011, col=cls)

#Bande di Landsat
#B1 = Blu
#B2 = verde
#B3 = rosso
#B4 = infrarosso vicino 
#B5 = infrarosso medio 
#B6 = infrarosso lontano o infrarosso termico 
#B7 = infrarosso medio

#pulire la finestra grafica
dev.off()

#plotto solo la banda del blu (B1_sre) dell'immagine p224r63_2011
# uso $ per legare le due cose
plot(p224r63_2011$B1_sre)

#posso plottare con la palette creata in precedenza
plot(p224r63_2011$B1_sre, col=cls)


#plotto due bande una accanto all'altra (es. blu e verde), quindi su una riga e due colonne
par(mfrow=c(1,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

#posso metterle anche su due righe e una colonna
par(mfrow=c(2,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

#in due righe e due colonne
#par(mfrow=c(2,2)) #e scelgo le 4 bande da visualizzare

#Visualizzare i dati con RGB plotting
#schema RGB = schema fisso per la rappresentazione dei colori, si possono visualizzare 3 bande per volta
#per visualizzare i colori naturali, si montano nel seguente modo:
#banda 3 --> R (RED)
#banda 2 --> G (GREEN)
#banda 1 --> B (BLUE)
#uso la funzione plotRGB(), i cui argomenti sono:
# 1) l'immagine originale che stiamo utilizzando = p224r63_2011
# 2) dobbiamo spiegare al sistema quali componenti associamo alle singole bande
#     r = 3, g = 2, b = 1
# 3) stretch --> prende i valori di riflettanza delle singole bande e le si "tira" perché non ci sia uno schiacciamento dei valori in una songola banda, utilizzando una funzione lineare
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")

#giochiamo con i colori
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin") #abbiamo tolto la banda del blu e montato l'infrarosso vicino nella componente RED
plotRGB(p224r63_2011, r=5, g=4, b=3, stretch="Lin")
plotRGB(p224r63_2011, r=6, g=5, b=4, stretch="Lin") #solo infrarosso
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin") #la vegetazione diventa verde brillante, viola suolo nudo
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin") #infrarosso montato nella componente blu, la vegetazione diventa blu, il suolo nudo giallo

#salvare l'immagine tramite script come pdf
pdf("plot_Brazil.pdf")
#montiamo 4 immagini una accanto all'altra
par(mfrow=c(2,2))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")

#ci sono altre funzioni di stretching
#esempio: pendenza maggiore nei valori intermedi (andamento sigmoidale) --> histogram stretch
par(mfrow=c(3,1))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin") #colori naturali
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin") #infrarosso su green e funzione lineare
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist") #si vedono bene zone più umide all'interno della foresta, differenze potenziali nella foresta

#installare un pacchetto per fare un'analisi statistica (PGA)
install.packages("RStoolbox")
#per usarlo:
library(RStoolbox)

