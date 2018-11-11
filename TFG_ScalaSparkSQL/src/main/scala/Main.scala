import org.apache.spark.sql.SparkSession
import org.apache.hadoop.fs.{FileSystem, Path}
import scala.util.control.Breaks._
import scalaj.http.Http


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

    val datePattern = "(\\d{4})-(\\d{2})-(\\d{2})[T](\\d{2})[:](\\d{2})".r
    val datePattern(startYear, startMonth, startDay, startHour, startMinute) = args(0)
    val datePattern(endYear, endMonth, endDay, endHour, endMinute) = args(1)
    val executionId = args(2)

    println()
    println("Start Date: " + startYear + "-" + startMonth + "-" + startDay + "T" + startHour + ":" + startMinute)
    println()
    println("End Date: " + endYear + "-" + endMonth + "-" + endDay + "T" + endHour + ":" + endMinute)
    println()
    println("Execution ID: " + executionId)
    println()

    val fs = FileSystem.get(sc.hadoopConfiguration)
    @transient val filesPuntosMedida = fs.listStatus(new Path("/datos.madrid.es_2018/PuntosMedida"))

    var selectedFileNamePuntosMedida = ""
    var selectedFileNameVelocidadMedia = ""

    breakable {
      for (file <- filesPuntosMedida) {
        val filePath = file.getPath.toString.split("/")
        val fileName = filePath(filePath.size - 1)
        val filePattern = "(\\d{2})-(\\d{4})[.]csv".r
        val filePattern(fileMonth, fileYear) = fileName
        if (fileMonth.equals(startMonth)) {
          selectedFileNamePuntosMedida = "/datos.madrid.es_2018/PuntosMedida/" + fileName
          selectedFileNameVelocidadMedia = "/datos.madrid.es_2018/VelocidadMedia/" + fileName
          break
        }
      }
    }

    if (selectedFileNamePuntosMedida.isEmpty()) {
      println()
      println("ERROR: No se ha encontrado dataset")
      println()
      spark.close()
      System.exit(-1)
    }

    println()
    println("VelocidadMedia: " + selectedFileNameVelocidadMedia)
    println()
    println("PuntosMedida: " + selectedFileNamePuntosMedida)
    println()

    // Sistema de ficheros local "file://ruta/fichero", HDFS (por defecto) "hdfs://ruta/directorio"
    val df1 = spark.read.option("header","true").option("delimiter", ";").csv(selectedFileNameVelocidadMedia)
    df1.createOrReplaceTempView("VelocidadMedia")

    // Obtenemos la época fecha >= startDate && fecha <= endDate
    val sql1 = "SELECT * FROM VelocidadMedia WHERE (dayofmonth(fecha) >= " + startDay + " AND dayofmonth(fecha) <= " + endDay + ") AND (hour(fecha) >= " + startHour + " AND hour(fecha) <= " + endHour + ") AND (minute(fecha) >= " + startMinute + " AND minute(fecha) <= " + endMinute + ")"
    val resultSql1 = spark.sql(sql1)

    resultSql1.printSchema()

    /**
      * root
      * 0 |-- id: string (nullable = true)
      * 1 |-- fecha: string (nullable = true)
      * 2 |-- tipo_elem: string (nullable = true)
      * 3 |-- intensidad: string (nullable = true)
      * 4 |-- ocupacion: string (nullable = true)
      * 5 |-- carga: string (nullable = true)
      * 6 |-- vmed: string (nullable = true)
      * 7 |-- error: string (nullable = true)
      * 8 |-- periodo_integracion: string (nullable = true)
      */
    resultSql1.sqlContext.table("VelocidadMedia").foreach(row =>
      Http("http://localhost:3000/speeds/insert")
        .postForm(Seq("ident" -> row.get(0).toString, "date" -> row.get(1).toString, "element" -> row.get(2).toString, "vmed" -> row.get(6).toString, "executionId" -> executionId))
        .asString
    )

    spark.stop()

    // Primero empaquetar la app con sbt package

    // /home/alejandro/Documentos/TFG_RailsSparkSQL/db/development.sqlite3

    // Lanzar la APP spark stand-alone
    // spark-submit --class SparkSQL --name "SparkSQL alopez" target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar

    // Lanzar la APP sobre clúster Yarn (hadoop)
    // spark-submit --master yarn --deply-mode cluster --class SparkSQL --name "TEST" target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar
  }

}