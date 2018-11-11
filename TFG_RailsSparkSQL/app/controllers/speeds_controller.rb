class SpeedsController < ApplicationController
  def insert
    if request.method == "POST"
      Speed.create(ident: params[:ident], date: params[:date], element: params[:element], vmed: params[:vmed], executionId: params[:executionId])
      render json: {type: "Status", message: "Ok"}
    end
  end
end
