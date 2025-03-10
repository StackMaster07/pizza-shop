class ToppingsController < ApplicationController
  include Pundit::Authorization
  before_action :set_topping, only: %i[edit update destroy]

  def index
    @toppings = policy_scope(Topping).order(:created_at)
    @topping = Topping.new
  rescue StandardError => e
    flash[:error] = "An error occurred while loading toppings: #{e.message}"
    redirect_to root_path
  end

  def create
    @topping = Topping.new(topping_params)
    authorize @topping
    if @topping.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('toppings_form', partial: 'form', locals: { topping: Topping.new }),
            turbo_stream.append('toppings_list', partial: 'topping', locals: { topping: @topping })
          ]
        end
        format.html { redirect_to toppings_path, notice: 'Topping successfully created!' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('toppings_form', partial: 'form', locals: { topping: @topping })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @topping
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('toppings_form', partial: 'form', locals: { topping: @topping })
      end
      format.html
    end
  end  

  def update
    authorize @topping
    if @topping.update(topping_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('toppings_form', partial: 'form', locals: { topping: Topping.new }),
            turbo_stream.replace("topping_#{@topping.id}", partial: 'topping', locals: { topping: @topping })
          ]
        end
        format.html { redirect_to toppings_path, notice: 'Topping was successfully updated.' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('toppings_form', partial: 'form', locals: { topping: @topping })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @topping
    if @topping.destroy
      respond_to do |format|
        format.html { redirect_to toppings_path, notice: 'Topping was successfully deleted.' }
        format.turbo_stream
      end
    else
      flash[:error] = "An error occurred while deleting the topping."
      redirect_to toppings_path
    end
  end

  private

  def set_topping
    @topping = Topping.find_by(id: params[:id])
  end

  def topping_params
    params.require(:topping).permit(:name, :quantity, :price_per_piece)
  end
end
