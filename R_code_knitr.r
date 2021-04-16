# R_code_knitr.r

#Imposto la working directory su Windows
setwd("C:/lab/")

#scaricare il pacchetto knitr
#install.packages("knitr")

library(knitr) #posso usare anche la funzione require(knitr)

#andiamo a generare un Report da un codice salvato in precedenza che verrà salvato nella cartella precedente
stitch("C:/lab/R_code_greenland.r", template=system.file("misc", "knitr-template.Rnw", package="knitr"))

#ne uscirà un file.tex (si dice TEC) che avrà lo stesso nome del file di partenza
#crea anche una cartella con le figure plottate nel codice
#possiamo trasformarlo in pdf sul sito Overleaf!

