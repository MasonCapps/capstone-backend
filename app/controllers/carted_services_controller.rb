class CartedServicesController < ApplicationController
  before_action :authenticate_user

  def index
    site = Site.find_by(id: params[:site_id])
    @carted_services = site.carted_services.where(status: "carted")
    @carted_services = @carted_services.order(created_at: :desc)
    render template: "carted_services/index"
  end

  def create
    carted_service = CartedService.new(
      site_id: params[:site_id],
      service_id: params[:service_id],
      user_id: current_user.id,
      order_id: nil,
      scheduled_date: params[:scheduled_date],
      status: "carted",
    )
    if carted_service.save
      @carted_service = carted_service
      render template: "carted_services/show"
    else
      render json: { errors: carted_service.errors.full_messages }, status: 422
    end
  end

  def destroy
    carted_service = CartedService.find_by(id: params[:id])
    carted_service.destroy
    render json: { message: "Carted service successfully deleted!" }
  end
end
