library(data.table)

# Coordenadas x e y = EPSG:25830
# Coordenadas lat y long = EPSG:4326 WGS 84

# El 1 cambiar M-30 por M30 y cambiar sistema de coordenadas
csv01 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/01-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv01 <- as.data.table(csv01)[tipo_elem == "M-30", tipo_elem := "M30"][]
csv01$x <- gsub(",","\\.",csv01$x)
csv01$y <- gsub(",","\\.",csv01$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/01-2018.csv", csv01)
csv01 <- NULL

# Del 2 al 4 solo cambiar sistema de coordenadas
csv02 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/02-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv02$x <- gsub(",","\\.",csv02$x)
csv02$y <- gsub(",","\\.",csv02$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/02-2018.csv", csv02)
csv02 <- NULL

csv03 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/03-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv03$x <- gsub(",","\\.",csv03$x)
csv03$y <- gsub(",","\\.",csv03$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/03-2018.csv", csv03)
csv03 <- NULL

csv04 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/04-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv04$x <- gsub(",","\\.",csv04$x)
csv04$y <- gsub(",","\\.",csv04$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/04-2018.csv", csv04)
csv04 <- NULL

# Del 5 al 9 mover columnas y cambiar sistema de coordenadas
csv05 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/05-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv05 <- csv05[,c(2,3,4,1,5,6)]
csv05$x <- gsub(",","\\.",csv05$x)
csv05$y <- gsub(",","\\.",csv05$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/05-2018.csv", csv05)
csv05 <- NULL

csv06 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/06-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv06 <- csv06[,c(3,2,4,1,5,6)]
csv06$x <- gsub(",","\\.",csv06$x)
csv06$y <- gsub(",","\\.",csv06$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/06-2018.csv", csv06)
csv06 <- NULL

csv07 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/07-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv07 <- csv07[,c(3,2,4,1,5,6)]
csv07$x <- gsub(",","\\.",csv07$x)
csv07$y <- gsub(",","\\.",csv07$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/07-2018.csv", csv07)
csv07 <- NULL

csv08 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/08-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv08 <- csv08[,c(3,2,4,1,5,6)]
csv08$x <- gsub(",","\\.",csv08$x)
csv08$y <- gsub(",","\\.",csv08$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/08-2018.csv", csv08)
csv08 <- NULL

csv09 <- read.csv(file="/home/alejandro/Documentos/PuntosMedida/09-2018.csv", header=T, sep=";", stringsAsFactors = T)
csv09 <- csv09[,c(3,2,4,1,5,6)]
csv09$x <- gsub(",","\\.",csv09$x)
csv09$y <- gsub(",","\\.",csv09$y)
write.table(sep=";",row.names=FALSE,file="/home/alejandro/Documentos/PuntosMedidaModificados/09-2018.csv", csv09)
csv09 <- NULL
