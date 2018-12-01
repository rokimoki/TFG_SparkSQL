#Load CSV Data
laptopData <- read.csv(
  file="/home/alejandro/Documentos/TFG_RSpeedUp/data/laptopData.csv",
  header=T,
  sep=";",
  stringsAsFactors = T
)

clusterSingleNodeData <- read.csv(
  file="/home/alejandro/Documentos/TFG_RSpeedUp/data/clusterSingleNodeData.csv", 
  header=T, 
  sep=";", 
  stringsAsFactors = T
)

clusterData <- read.csv(
  file="/home/alejandro/Documentos/TFG_RSpeedUp/data/clusterData.csv",
  header=T, 
  sep=";", 
  stringsAsFactors = T
)

# Calculate execution times in minutes
globalData <- data.frame(
  laptopData = as.integer(difftime(
    as.POSIXlt(laptopData$Execution_End, format="%Y-%m-%d %H:%M:%S"), 
    as.POSIXlt(laptopData$Execution_Start, format="%Y-%m-%d %H:%M:%S"),
    units="secs")
  ),
  clusterSingleNodeData = as.integer(difftime(
    as.POSIXlt(clusterSingleNodeData$Execution_End, format="%Y-%m-%d %H:%M:%S"), 
    as.POSIXlt(clusterSingleNodeData$Execution_Start, format="%Y-%m-%d %H:%M:%S"),
    units="secs")
  ),
  clusterData = as.integer(difftime(
    as.POSIXlt(clusterData$Execution_End, format="%Y-%m-%d %H:%M:%S"), 
    as.POSIXlt(clusterData$Execution_Start, format="%Y-%m-%d %H:%M:%S"),
    units="secs")
  )
)

# Get the mean execution time, given by 10 execution time samples
laptopDataMean = mean(globalData$laptopData)
clusterSingleNodeDataMean = mean(globalData$clusterSingleNodeData)
clusterDataMean = mean(globalData$clusterData)

dataForPlot <- c(
  clusterSingleNodeDataMean / laptopDataMean,
  clusterDataMean / laptopDataMean,
  clusterSingleNodeDataMean / clusterDataMean
)

barplot (
  dataForPlot,
  main = "Speedup Test",
  xlab = "Test type",
  ylab = "Performance %",
  col = c("darkblue", "red", "darkgreen"),
  names.arg = c("Laptop over Single Node", "Laptop over Cluster", "Cluster over Single Node"),
  beside = TRUE
)
