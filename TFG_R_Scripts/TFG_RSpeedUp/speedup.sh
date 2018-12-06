#!/bin/bash
echo "Realizando SpeedUp Cluster Mode"

for i in {1..100}
do
    echo "Ejecucion numero $i"
    spark-submit --class SparkSQL --master yarn --deploy-mode client --conf spark.dynamicAllocation.enabled=true --conf spark.shuffle.service.enabled=true --conf spark.dynamicAllocation.minExecutors=7 --conf spark.driver.cores=1 --conf spark.driver.memory=6g --conf spark.executor.memory=6g /home/alopez/proyecto/tfg_scalasparksql_2.11-0.1.jar "2018-05-04 10:20" "2018-05-04 10:50" cluster_$i > cluster_mode_execution_$i.txt
done

echo "Realizando SpeedUp Single Node Mode"
for i in {1..100}
do
    echo "Ejecucion numero $i"
    spark-submit --class SparkSQL --master yarn --deploy-mode client --conf spark.dynamicAllocation.enabled=true --conf spark.shuffle.service.enabled=true --conf spark.dynamicAllocation.maxExecutors=1 --conf spark.driver.cores=1 --conf spark.driver.memory=6g --conf spark.executor.memory=6g /home/alopez/proyecto/tfg_scalasparksql_2.11-0.1.jar "2018-05-04 10:20" "2018-05-04 10:50" single_$i > single_node_$i.txt
done
