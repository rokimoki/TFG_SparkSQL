require 'csv'
class EpochesController < ApplicationController
  def index
    @startDateRandom = (Time.now - 4.months - 30.minutes).in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
    @endDateRandom = (Time.now - 4.months).in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

  def map
    # Standalone
    # spark-submit --class SparkSQL --name "SparkSQL alopez" target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar "2018-05-04 10:20" "2018-05-04 10:50" 12345
    # Cluster
    # spark-submit --class SparkSQL --master yarn --deploy-mode client --conf spark.dynamicAllocation.enabled=true --conf spark.shuffle.service.enabled=true --conf spark.dynamicAllocation.minExecutors=7 --conf spark.driver.cores=1 --conf spark.driver.memory=6g --conf spark.executor.memory=6g /home/alopez/proyecto/tfg_scalasparksql_2.11-0.1.jar "2018-05-04 10:20" "2018-05-04 10:50" 12345
  @executed = 0
    if request.method == "POST"
      @startDate = params[:startDate].in_time_zone("Europe/London").strftime("%Y-%m-%d %H:%M")
      @endDate = params[:endDate].in_time_zone("Europe/London").strftime("%Y-%m-%d %H:%M")
      executionId = SecureRandom.uuid
      if @execution = `spark-submit --class SparkSQL --name "TFG_RailsSparkSQL" /home/alejandro/Documentos/TFG_ScalaSparkSQL/target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar "#{@startDate}" "#{@endDate}" #{executionId}`
        @executed = 1
        if `hdfs dfs -get "/salida/#{executionId}/*.csv" #{Rails.root}/salida/#{executionId}.csv`
          if `hdfs dfs -rm -r /salida/#{executionId}`
            csvFile = File.read("#{Rails.root}/salida/#{executionId}.csv")
            CSV.parse(csvFile, { headers: true, col_sep: "," }).each do | row |
              Speed.create ident: row[0].to_s, element: row[1].to_s, vmed: row[2].to_s, executionId: executionId
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
    @executed = 0
    @extracted = 0
    @deleted = 0
    @startDate = "2018-05-04 10:20"
    @endDate = "2018-05-04 20:50"
    executionId = SecureRandom.uuid
    if @execution = `spark-submit --class SparkSQL --name "TFG_RailsSparkSQL" /home/alejandro/Documentos/TFG_ScalaSparkSQL/target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar "#{@startDate}" "#{@endDate}" #{executionId}`
      @executed = 1
      if @extraction = `hdfs dfs -get "/salida/#{executionId}/*.csv" #{Rails.root}/salida/#{executionId}.csv`
        @extracted = 1
        if @deletion = `hdfs dfs -rm -r /salida/#{executionId}`
          @deleted = 1
          csvFile = File.read("#{Rails.root}/salida/#{executionId}.csv")
          CSV.parse(csvFile, { headers: true, col_sep: "," }).each do | row |
            Speed.create ident: row[0].to_s, element: row[1].to_s, vmed: row[2].to_s, executionId: executionId
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
  end

end