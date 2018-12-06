# Prepare TXT Output to dataframes
startDateSingle <- read.csv(
  file="data/single_start.csv",
  header=F
)

endDateSingle <- read.csv(
  file="data/single_end.csv",
  header=F
)

# De 100 muestras han fallado la ejecucuón 79, 71, 56, 14 (4 de 100, 96 muestras)
clusterSingleNodeData <- data.frame(
  Execution_Start = startDateSingle$V1,
  Execution_End = endDateSingle$V1
)

startDateCluster <- read.csv(
  file="data/cluster_start.csv",
  header=F
)

endDateCluster <- read.csv(
  file="data/cluster_end.csv",
  header=F
)

# De 100 muestras ningún error
clusterData <- data.frame(
  Execution_Start = startDateCluster$V1,
  Execution_End = endDateCluster$V1
)

#Load CSV Data (10 muestras)
laptopData <- read.csv(
  file="data/laptopData.csv",
  header=T,
  sep=";",
  stringsAsFactors = T
)

# Calculate execution times in minutes
laptopData = as.integer(difftime(
    as.POSIXlt(laptopData$Execution_End, format="%Y-%m-%d %H:%M:%S"), 
    as.POSIXlt(laptopData$Execution_Start, format="%Y-%m-%d %H:%M:%S"),
    units="secs")
)

clusterSingleNodeData = as.integer(difftime(
    as.POSIXlt(clusterSingleNodeData$Execution_End, format="%Y-%m-%d %H:%M:%S"), 
    as.POSIXlt(clusterSingleNodeData$Execution_Start, format="%Y-%m-%d %H:%M:%S"),
    units="secs")
)

clusterData = as.integer(difftime(
  as.POSIXlt(clusterData$Execution_End, format="%Y-%m-%d %H:%M:%S"), 
  as.POSIXlt(clusterData$Execution_Start, format="%Y-%m-%d %H:%M:%S"),
  units="secs")
)

# Get the mean execution time, given by 10 execution time samples
laptopDataMean = mean(laptopData)
clusterSingleNodeDataMean = mean(clusterSingleNodeData)
clusterDataMean = mean(clusterData)

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
