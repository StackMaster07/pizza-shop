require 'rails_helper'

RSpec.describe PizzasController, type: :controller do
  let(:chef) { create(:user, role: :chef) }
  let(:owner) { create(:user, role: :owner) }
  let(:pizza) { create(:pizza, chef: chef) }
  let(:valid_attributes) { attributes_for(:pizza).merge(pizza_toppings_attributes: []) }
  let(:invalid_attributes) { { name: '', description: '', size: nil } }

  before { sign_in chef }

  describe "GET #index" do
    it "assigns all pizzas as @pizzas" do
      pizza
      get :index
      expect(assigns(:pizzas)).to include(pizza)
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Pizza" do
        expect {
          post :create, params: { pizza: valid_attributes }, format: :turbo_stream
        }.to change(Pizza, :count).by(1)
      end

      it "renders the turbo_stream response" do
        post :create, params: { pizza: valid_attributes }, format: :turbo_stream
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(partial: '_form')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Pizza" do
        expect {
          post :create, params: { pizza: invalid_attributes }, format: :turbo_stream
        }.not_to change(Pizza, :count)
      end

      it "renders errors via turbo_stream" do
        post :create, params: { pizza: invalid_attributes }, format: :turbo_stream
        expect(response).to have_http_status(:unprocessable_entity)
        expect(assigns(:pizza).errors).not_to be_empty
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested pizza as @pizza" do
      get :edit, params: { id: pizza.id }, format: :turbo_stream
      expect(assigns(:pizza)).to eq(pizza)
    end

    it "renders the turbo_stream response" do
      get :edit, params: { id: pizza.id }, format: :turbo_stream
      expect(response).to render_template(partial: '_form')
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the requested pizza" do
        new_name = "Updated Pizza"
        patch :update, params: { id: pizza.id, pizza: { name: new_name } }, format: :turbo_stream
        pizza.reload
        expect(pizza.name).to eq(new_name)
      end

      it "renders turbo_stream response" do
        patch :update, params: { id: pizza.id, pizza: { name: "Updated Name" } }, format: :turbo_stream
        expect(response).to render_template(partial: '_pizza')
      end
    end

    context "with invalid parameters" do
      it "does not update the pizza" do
        patch :update, params: { id: pizza.id, pizza: { name: '' } }, format: :turbo_stream
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested pizza" do
      pizza
      expect {
        delete :destroy, params: { id: pizza.id }, format: :turbo_stream
      }.to change(Pizza, :count).by(-1)
    end

    it "renders the turbo_stream response" do
      delete :destroy, params: { id: pizza.id }, format: :turbo_stream
      expect(response).to render_template(partial: 'shared/_flash_messages')
    end
  end
end
