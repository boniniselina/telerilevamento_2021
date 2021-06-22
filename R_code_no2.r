# R_code_no2.r

library(raster)
library(RStoolbox)


# 1. Set the working directory EN in Windows
setwd("C:/lab/EN/")

# 2. Import the first image (single band)
EN01 <- raster("EN_0001.png")

#3. Plot the first imported image with preferred Color Ramp Palette
cl <- colorRampPalette(c("purple","pink","orange","yellow")) (200)
plot(EN01, col=cl)

# 4. Import the last image (13th) and plot it with the previous Color Ramp Palette
EN13 <- raster("EN_0013.png")
plot(EN13, col=cl)

# 5. Make the difference between two images and plot it
# March - Jenuary

ENdiff <- EN13-EN01
plot(ENdiff, col=cl)

# 6. Total plot
par(mfrow=c(3,1))
plot(EN01, col=cl, main="NO2 in January")
plot(EN13, col=cl, main="NO2 in March")
plot(ENdiff, col=cl, main="Difference (March - January)")

# 7. Import the whole set

# list of file
rlist <- list.files(pattern="EN")
import <- lapply(rlist, raster)
EN <- stack(import)
plot(EN, col=cl)

# 8. Replicate the plot of images 1 and 13 using the stack
par(mfrow=c(2,1))
plot(EN$EN_0001, col=cl, main="NO2 in January")
plot(EN$EN_0013, col=cl, main="NO2 in March")

ENdiffst <- EN$EN_0013 - EN$EN_0001
plot(ENdiffst, col=cl)

# 9. Compute a PCA over the 13 images
EN_pca <- rasterPCA(EN)
summary(EN_pca$model)

plotRGB(EN_pca$map, 1, 2, 3, stretch="lin")

# 10. Compute the variability (local standard deviation) of PCA
EN_pca_sd5 <- focal(EN_pca$map$PC1, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue', 'green', 'magenta', 'orange', 'brown', 'red', 'yellow'))(100)
plot(EN_pca_sd5, col= clsd)


