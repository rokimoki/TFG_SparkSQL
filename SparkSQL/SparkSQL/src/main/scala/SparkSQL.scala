import org.apache.spark.sql.SparkSession

object SparkSQL {

  def main (args: Array[String]){

    val spark = SparkSession
      .builder()
      .appName("Spark SQL lectura CSV")
      .getOrCreate()

    // Necesario para utilizar la notación con $
    import spark.implicits._

    // Sistema de ficheros local "file://ruta/fichero", HDFS (por defecto) "hdfs://ruta/directorio"
    val df = spark.read.option("header","true").option("delimiter", ";").csv("/datos.madrid.es.lite/dataset/06-2017.csv")

    df.printSchema()

    println()

    // Operaciones con datasets (aka operaciones con dataframes)
    df.filter($"vmed" > 20 and $"vmed" < 70).show()

    println()

    // Consultas SQL programaticamente
    df.createOrReplaceTempView("medidas")

    val result = spark.sql("SELECT * FROM medidas WHERE vmed > 20 and vmed < 70")

    result.show()

    println()

    spark.stop()

    // Primero empaquetar la app con sbt package

    // Lanzar la APP spark stand-alone
    // spark-submit --class SparkSQL --name "SparkSQL alopez" target/scala-2.11/sparksql_2.11-0.1.jar

    // Lanzar la APP sobre clúster Yarn (hadoop)
    // spark-submit --master yarn --deply-mode cluster --class SparkSQL --name "TEST" target/scala-2.11/sparksql_2.11-0.1.jar
  }

}
