class PizzasController < ApplicationController
  include Pundit::Authorization
    
  before_action :set_pizza, only: %i[edit update destroy]
  before_action :set_chef, only: %i[create]

  def index
    @pizzas = policy_scope(Pizza).includes(:toppings, :pizza_toppings)
    @pizza = Pizza.new
  rescue StandardError => e
    flash[:error] = "An error occurred while loading pizzas: #{e.message}"
    redirect_to pizzas_path
  end

  def create
    @pizza = @chef.pizzas.new(pizza_params)
    authorize @pizza

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
      render turbo_stream: turbo_stream.replace('flash-container', partial: 'shared/flash_messages'), status: :unprocessable_entity
      redirect_to pizzas_path
    end
  end

  def edit
    authorize @pizza

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('pizza_form', partial: 'form', locals: { pizza: @pizza })
      end
      format.html
    end
  end  

  def update
    authorize @pizza
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
    authorize @pizza
    @pizza.destroy!
  
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove("pizza_#{@pizza.id}"),
          turbo_stream.replace('flash-container', partial: 'shared/flash_messages', locals: { flash: { notice: 'Pizza was successfully deleted.' } })
        ]
      end
      format.html { redirect_to pizzas_path, notice: "Pizza was successfully deleted." }
    end
  rescue ActiveRecord::RecordNotDestroyed => e
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("flash-container", partial: "shared/flash_messages", locals: { flash: { alert: "Could not delete pizza." } }),
               status: :unprocessable_entity
      end
      format.html { redirect_to pizzas_path, alert: "Could not delete pizza." }
    end
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
end
