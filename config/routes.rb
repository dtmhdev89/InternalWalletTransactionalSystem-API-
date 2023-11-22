Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope "api/v1", module: "api/v1" do
    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"
  end
end
