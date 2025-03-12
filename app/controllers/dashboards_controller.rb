class DashboardsController < ApplicationController
  def index
    if current_user.chef?
      redirect_to pizzas_path
    else
      redirect_to toppings_path
    end
  end
end
