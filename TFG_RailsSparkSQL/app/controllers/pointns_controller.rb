require 'csv'
require 'pp'
class PointnsController < ApplicationController
  def insert
    if request.method == "POST"
      Point.create(ident: params[:ident], name: params[:name], element: params[:element], x: params[:x], y: params[:y], executionId: params[:executionId])
      render json: {type: "Status", message: "Ok"}
    end
  end

  def loadCsv
    files = ["01-2018.csv", "02-2018.csv", "03-2018.csv",
             "04-2018.csv", "05-2018.csv", "06-2018.csv",
             "07-2018.csv", "08-2018.csv", "09-2018.csv"]
    files.each do | each |
      csvFile = File.read("PuntosMedida/#{each}")
      CSV.parse(csvFile, { headers: true, col_sep: ";" }).each do | row |
        Point.create ident: row[1].to_s, name: row[2].to_s, element: row[3].to_s, x: row[4].to_s, y: row[5].to_s, executionId: each.to_s
      end
    end
    render json: {type: "Status", message: "Ok"}
  end

  def testDirectory
    Dir.foreach("d6071838-def2-4768-b98d-00fb1a1b2ffc/") do | file |
      printf("1.- %s\n", file)
      if File.extname(file) == ".csv"
        printf("2.- Entró: %s\n", file)
        csvFile = File.read("d6071838-def2-4768-b98d-00fb1a1b2ffc/#{file}")
        pp csvFile
        CSV.parse(csvFile, { headers: true, col_sep: ";" }).each do | row |
          printf("3.- ID %s\n", row[1])
          #Speed.create ident: row[1], name: row[2], element: row[3], vmed: row["vmed"], executionId: "d6071838-def2-4768-b98d-00fb1a1b2ffc"
        end
      end
    end
    render json: {type: "Status", message: "Ok"}
  end
end
