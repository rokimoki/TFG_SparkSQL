name := "TFG_ScalaSparkSQL"

version := "0.1"

scalaVersion := "2.11.8"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % "2.3.0",
  "org.apache.spark" %% "spark-sql" % "2.3.0",
  "org.scalaj" % "scalaj-http_2.11" % "2.3.0"
)