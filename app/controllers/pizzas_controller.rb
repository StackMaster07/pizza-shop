class PizzasController < ApplicationController
  before_action :set_pizza, only: %i[edit update destroy]
  before_action :set_chef, only: %i[create]

  def index
    @pizzas = get_user_pizzas
    @pizza = Pizza.new
  rescue StandardError => e
    flash[:error] = "An error occurred while loading pizzas: #{e.message}"
    redirect_to pizzas_path
  end

  def create
    @pizza = @chef.pizzas.new(pizza_params)

    if @pizza.save
      update_toppings(@pizza, params[:pizza][:pizza_toppings_attributes])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('pizza_form', partial: 'form', locals: { pizza: Pizza.new }),
            turbo_stream.append('pizza_list', partial: 'pizza', locals: { pizza: @pizza })
          ]
        end
        format.html { redirect_to pizzass_path, notice: 'Pizza successfully created!' }
      end
    else
      flash[:error] = 'An error occurred while Creating the pizza'
      redirect_to pizzas_path
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('pizza_form', partial: 'form', locals: { pizza: @pizza })
      end
      format.html
    end
  end  

  def update
    if @pizza.update(pizza_params)
      update_toppings(@pizza, params[:pizza][:pizza_toppings_attributes])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('pizza_form', partial: 'form', locals: { pizza: Pizza.new }),
            turbo_stream.replace("pizza_#{@pizza.id}", partial: 'pizza', locals: { pizza: @pizza })
          ]
        end
        format.html { redirect_to pizzas_path, notice: 'Pizza was successfully updated.' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('pizza_form', partial: 'form', locals: { pizza: @pizza })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @pizza.destroy!
  
    respond_to do |format|
      format.html { redirect_to pizzas_path, notice: 'Pizza was successfully deleted.' }
      format.turbo_stream
    end
  rescue ActiveRecord::RecordNotDestroyed => e
    flash[:error] = "An error occurred while deleting the pizza: #{e.message}"
    redirect_to pizzas_path
  end

  private

  def set_pizza
    @pizza = Pizza.find_by(id: params[:id])
  end

  def set_chef
    @chef = current_user
  end

  def pizza_params
    params.require(:pizza).permit(:name, :description, :size)
  end

  def update_toppings(pizza, toppings_params)
    return unless toppings_params

    ActiveRecord::Base.transaction do
      pizza.pizza_toppings.destroy_all

      toppings_params.each do |topping_data|
        topping = Topping.find_by(id: topping_data[:topping_id])
        next unless topping

        quantity_used = topping_data[:quantity].to_i

        if topping.quantity >= quantity_used
          pizza.pizza_toppings.create!(topping: topping, quantity: quantity_used)
          topping.update!(quantity: topping.quantity - quantity_used)
        else
          flash[:error] = "Not enough stock for #{topping.name}."
          raise ActiveRecord::Rollback
        end
      end
    end

    pizza.save!
  end

  def get_user_pizzas
    current_user.chef? ? current_user.pizzas.includes(:toppings, :pizza_toppings) : Pizza.include(:toppings, :pizza_toppings)
  end
end
