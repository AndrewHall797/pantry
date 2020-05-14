Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  #Routes for users
  post 'users/add_ingredients' => 'users#add_ingredients'
  delete 'users/remove_ingredient' => 'users#remove_ingredient'
  patch 'users/update_ingredient' => 'users#update_ingredient'
  get 'users/show_pantry' => 'users#show_pantry'

  #Routes for recipes
  post 'recipes/create_with_steps' => 'recipes#create_with_steps'
  post 'recipes/add_ingredient' => 'recipes#add_ingredient'
  delete 'recipes/remove_ingredient' => 'recipes#remove_ingredient'
  post 'recipes/add_step' => 'recipes#add_step'
  get 'recipes/created_recipes' => 'recipes#created_recipes'
  get 'recipes/bookmarked_recipes' => 'recipes#bookmarked_recipes'
  post 'recipes/bookmark' => 'recipes#bookmark'
  patch 'recipes/update_step_description' => 'recipes#update_step_description'
  patch 'recipes/update_step_number' => 'recipes#update_step_number'
  get 'recipes/get_recipe_and_steps' => 'recipes#get_recipe_and_steps'

  resources :users
  resources :recipes
end
