require 'csv'
class EpochesController < ApplicationController
  def index
    @startDateRandom = (Time.now - 4.months - 30.minutes).in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
    @endDateRandom = (Time.now - 4.months).in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

  def map
    # spark-submit --class SparkSQL --name "EpochSelector" /home/alejandro/Documentos/TFG_SparkSQL/target/scala-2.11/tfg_sparksql_2.11-0.1.jar
    # spark-submit --master yarn --deply-mode cluster --class SparkSQL --name "EpochSelector" /home/alopez/proyecto/tfg_sparksql_2.11-0.1.jar
    @executed = 0
    if request.method == "POST"
      @startDate = params[:startDate].in_time_zone("Europe/London").strftime("%Y-%m-%d %H:%M")
      @endDate = params[:endDate].in_time_zone("Europe/London").strftime("%Y-%m-%d %H:%M")
      executionId = SecureRandom.uuid
      if @execution = `spark-submit --class SparkSQL --name "EpochSelector" /home/alejandro/Documentos/TFG_ScalaSparkSQL/target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar "#{@startDate}" "#{@endDate}" #{executionId}`
        @executed = 1
        if `hdfs dfs -get "/salida/#{executionId}/*.csv" #{Rails.root}/salida/#{executionId}.csv`
          if `hdfs dfs -rm -r /salida/#{executionId}`
            csvFile = File.read("#{Rails.root}/salida/#{executionId}.csv")
            CSV.parse(csvFile, { headers: true, col_sep: "," }).each do | row |
              Speed.create ident: row[0].to_s, date: row[1].to_s, element: row[2].to_s, vmed: row[3].to_s, executionId: executionId
            end
            FileUtils.rm_rf("#{Rails.root}/salida/#{executionId}.csv")
            speedsRaw = Point.find_by_sql ["SELECT DISTINCT B.ident, B.name, B.x, B.y, A.vmed FROM speeds A INNER JOIN points B ON A.ident = B.ident WHERE A.executionId = ?", executionId]
            @speeds = []
            speedsRaw.each do |each|
              @speeds << [each["ident"], each["name"], each["x"].to_f, each["y"].to_f, each["vmed"].to_f, @startDate, @endDate]
            end
          end
        end
      end
      # GMaps Api-Key: AIzaSyCmlI7UDrPmPvyWoD6KGqAyo-X7TBjgXVA
      # MapBox Api-Key: pk.eyJ1Ijoicm9raW1va2kiLCJhIjoiY2pvd3lyeHpnMHNqMjNwcnA3MjV3NmJlbiJ9.KJj3l-EQJgvvnmv_l7fU-Q
    end
  end

  def map_test
    @coords = [["1001", "05FT10PM01", 437146.022667131, 4473498.17235059, 62.0],
              ["1001", "05FT10PM01", 437146.022667131, 4473498.17235059, 69.0],
              ["1002", "05FT37PM01", 436892.118105918, 4473311.64630953, 69.0],
              ["1002", "05FT37PM01", 436892.118105918, 4473311.64630953, 73.0],
              ["1003", "05FT66PM01", 436630.102140068, 4473180.04984782, 78.0],
              ["1003", "05FT66PM01", 436630.102140068, 4473180.04984782, 75.0],
              ["1006", "04FT74PM01", 437526.638490494, 4473735.29258508, 66.0],
              ["1009", "03FT52PM01", 438499.044503615, 4474208.99613704, 64.0],
              ["1009", "03FT52PM01", 438499.044503615, 4474208.99613704, 67.0],
              ["1010", "03FL56PM01", 438487.741512358, 4474217.82060848, 51.0]]
  end

  def dfs_test
    # spark-submit --class SparkSQL --name "EpochSelector" /home/alejandro/Documentos/TFG_SparkSQL/target/scala-2.11/tfg_sparksql_2.11-0.1.jar
    # spark-submit --master yarn --deply-mode cluster --class SparkSQL --name "EpochSelector" /home/alopez/proyecto/tfg_sparksql_2.11-0.1.jar
    @executed = 0
    @extracted = 0
    @deleted = 0
    @startDate = "2018-05-04 10:20"
    @endDate = "2018-05-04 10:50"
    executionId = SecureRandom.uuid
    if @execution = `spark-submit --class SparkSQL --name "EpochSelector" /home/alejandro/Documentos/TFG_ScalaSparkSQL/target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar "#{@startDate}" "#{@endDate}" #{executionId}`
      @executed = 1
      if `hdfs dfs -get "/salida/#{executionId}/*.csv" #{Rails.root}/salida/#{executionId}.csv`
        @extracted = 1
        if `hdfs dfs -rm -r /salida/#{executionId}`
          @deleted = 1
          csvFile = File.read("#{Rails.root}/salida/#{executionId}.csv")
          CSV.parse(csvFile, { headers: true, col_sep: "," }).each do | row |
            Speed.create ident: row[0].to_s, date: row[1].to_s, element: row[2].to_s, vmed: row[3].to_s, executionId: executionId
          end
          FileUtils.rm_rf("#{Rails.root}/salida/#{executionId}.csv")
        end
      end
    end
  end

end