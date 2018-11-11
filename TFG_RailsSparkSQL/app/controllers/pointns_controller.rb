class PointnsController < ApplicationController
  def insert
    if request.method == "POST"
      Point.create(ident: params[:ident], name: params[:name], element: params[:element], x: params[:x], y: params[:y], executionId: params[:executionId])
      render json: {type: "Status", message: "Ok"}
    end
  end
end
