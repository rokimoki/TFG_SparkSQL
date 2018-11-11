class EpochesController < ApplicationController
  def index
    @startDateRandom = (Time.now - 3.months - 5.minutes).in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
    @endDateRandom = (Time.now - 3.months).in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
  end

  def map
    # spark-submit --class SparkSQL --name "EpochSelector" /home/alejandro/Documentos/TFG_SparkSQL/target/scala-2.11/tfg_sparksql_2.11-0.1.jar
    # spark-submit --master yarn --deply-mode cluster --class SparkSQL --name "EpochSelector" /home/alopez/proyecto/tfg_sparksql_2.11-0.1.jar
    @executed = 0
    if request.method == "POST"
      @startDate = params[:startDate].in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
      @endDate = params[:endDate].in_time_zone("Europe/London").strftime("%Y-%m-%dT%H:%M")
      executionId = SecureRandom.uuid
      if @execution = `spark-submit --class SparkSQL --name "EpochSelector" /home/alejandro/Documentos/TFG_ScalaSparkSQL/target/scala-2.11/tfg_scalasparksql_2.11-0.1.jar #{@startDate} #{@endDate} #{executionId}`
        @executed = 1
      end
    end
  end
end