import org.apache.spark.sql.SparkSession
import org.apache.hadoop.fs.{FileSystem, Path}
import scala.util.control.Breaks._

object SparkSQL {

  def main (args: Array[String]) {

    val spark = SparkSession
      .builder()
      .appName("SparkSQL Data Loader")
      .getOrCreate()
    val sc = spark.sparkContext

    if (args.size != 3) {
      println()
      println("ERROR: Paso de parámetros inválidos")
      println()
      spark.close()
      System.exit(-1)
    }

    val datePattern = "(\\d{4})-(\\d{2})-(\\d{2})\\s(\\d{2})[:](\\d{2})".r
    val datePattern(startYear, startMonth, startDay, startHour, startMinute) = args(0)
    val datePattern(endYear, endMonth, endDay, endHour, endMinute) = args(1)

    val startDate = args(0)
    val endDate = args(1)
    val executionId = args(2)

    println()
    println("Start Date: " + startYear + "-" + startMonth + "-" + startDay + "T" + startHour + ":" + startMinute)
    println()
    println("End Date: " + endYear + "-" + endMonth + "-" + endDay + "T" + endHour + ":" + endMinute)
    println()
    println("Execution ID: " + executionId)
    println()

    val fs = FileSystem.get(sc.hadoopConfiguration)
    @transient val filesVelocidadMedia = fs.listStatus(new Path("/datos.madrid.es_2018/VelocidadMedia"))

    var selectedFileNameVelocidadMedia = ""

    breakable {
      for (file <- filesVelocidadMedia) {
        val filePath = file.getPath.toString.split("/")
        val fileName = filePath(filePath.size - 1)
        val filePattern = "(\\d{2})-(\\d{4})[.]csv".r
        val filePattern(fileMonth, fileYear) = fileName
        if (fileMonth.equals(startMonth)) {
          selectedFileNameVelocidadMedia = "/datos.madrid.es_2018/VelocidadMedia/" + fileName
          break
        }
      }
    }

    if (selectedFileNameVelocidadMedia.isEmpty()) {
      println()
      println("ERROR: No se ha encontrado dataset")
      println()
      spark.close()
      System.exit(-1)
    }

    println()
    println("VelocidadMedia: " + selectedFileNameVelocidadMedia)
    println()

    // Sistema de ficheros local "file://ruta/fichero", HDFS (por defecto) "hdfs://ruta/directorio"
    val df1 = spark.read.option("header","true").option("delimiter", ";").csv(selectedFileNameVelocidadMedia)

    println()
    df1.printSchema()
    println()

    // Obtenemos la época fecha >= startDate && fecha <= endDate y agrupamos por id y tipo_elem
    df1.createOrReplaceTempView("VelocidadMedia")
    val sql1 = "SELECT id, " +
                      "fecha, " +
                      "tipo_elem, " +
                "ROUND(AVG(vmed), 2) AS vmed " +
                "FROM VelocidadMedia " +
                "WHERE vmed > 0 " +
                   "AND (fecha >= '" + startDate + "') " +
                   "AND (fecha <= '" + endDate + "') " +
                "GROUP BY id, " +
                          "tipo_elem," +
                          "fecha " +
                "ORDER BY id, " +
                         "tipo_elem"
    val resultSql1 = spark.sql(sql1)
    resultSql1.printSchema()
    resultSql1.show()
    resultSql1.repartition(1).write.option("header","true").csv("/salida/" + executionId)

    spark.stop()

    // Primero empaquetar la app con sbt package

    // Lanzar la APP spark stand-alone
    // spark-submit --class SparkSQL --name "SparkSQL alopez" target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar "2018-05-04 10:20" "2018-05-04 10:50" 12345

    // Lanzar la APP sobre clúster Yarn (hadoop)
    // spark-submit --master yarn --deply-mode cluster --class SparkSQL --name "TEST" target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar
  }

}