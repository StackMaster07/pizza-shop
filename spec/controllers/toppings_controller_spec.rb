require 'rails_helper'

RSpec.describe ToppingsController, type: :controller do
  let(:chef) { create(:user, role: :chef) }
  let(:owner) { create(:user, role: :owner) }
  let(:topping) { create(:topping) }

  before do
    sign_in owner
  end

  describe "GET #index" do
    it "assigns @toppings and renders index" do
      create_list(:topping, 3)
      get :index
      expect(assigns(:toppings)).to match_array(Topping.order(:created_at))
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) { attributes_for(:topping) }

      it "creates a new topping" do
        expect {
          post :create, params: { topping: valid_params }, format: :turbo_stream
        }.to change(Topping, :count).by(1)
      end

      it "renders the correct Turbo Stream response" do
        post :create, params: { topping: valid_params }, format: :turbo_stream
        expect(response).to render_template(partial: '_form')
        expect(response).to render_template(partial: '_topping')
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { name: "" } }

      it "does not create a topping" do
        expect {
          post :create, params: { topping: invalid_params }, format: :turbo_stream
        }.not_to change(Topping, :count)
      end

      it "re-renders the form with errors" do
        post :create, params: { topping: invalid_params }, format: :turbo_stream
        expect(response).to render_template(partial: '_form')
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit form" do
      get :edit, params: { id: topping.id }, format: :turbo_stream
      expect(response).to render_template(partial: '_form')
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:updated_params) { { name: "Updated Topping" } }

      it "updates the topping" do
        patch :update, params: { id: topping.id, topping: updated_params }, format: :turbo_stream
        expect(topping.reload.name).to eq("Updated Topping")
      end

      it "renders the correct Turbo Stream response" do
        patch :update, params: { id: topping.id, topping: updated_params }, format: :turbo_stream
        expect(response).to render_template(partial: '_topping')
      end
    end

    context "with invalid parameters" do
      it "does not update the topping" do
        patch :update, params: { id: topping.id, topping: { name: "" } }, format: :turbo_stream
        expect(topping.reload.name).not_to eq("")
      end

      it "re-renders the form with errors" do
        patch :update, params: { id: topping.id, topping: { name: "" } }, format: :turbo_stream
        expect(response).to render_template(partial: '_form')
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:topping) { create(:topping) }

    it "deletes the topping" do
      expect {
        delete :destroy, params: { id: topping.id }, format: :turbo_stream
      }.to change(Topping, :count).by(-1)
    end

    it "renders the turbo stream response" do
      delete :destroy, params: { id: topping.id }, format: :turbo_stream
      expect(response).to have_http_status(:ok)
    end
  end
end
