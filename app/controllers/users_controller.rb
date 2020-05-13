class UsersController < ApplicationController

  #Creates a new user
  def create
    user = User.new(params.require(:user).permit(:username, :password_digest, :email))
    if user.save
      render json: "Success, new user created"
    else
      render json: "Failure, new user not created"
    end
  end

  #Sends back all users
  def index
    render json: {users: User.all}
  end

  #Deletes the user given a username
  def destroy
    if (user = User.find_by(username: params[:username])) != nil
      user.destroy
      render json: "Success the user was deleted"
    else
      render json: "Failure, the user was not deleted"
    end
  end

  #Sends back all the ingredients the user has in their pantry
  def get_pantry
    if (user = User.find_by(username: params[:username])) != nil
      render json: {pantry: Own.joins(:ingredients).where("users_id = ?", user.id).select(:name, :weight_value, :weight_unit, :volume_value, :volume_unit)}
    else
      render json: "Failure, the user does not exist"
    end
  end

  #Adds the ingredient to the users pantry.
  def add_ingredients
    if (user = User.find_by(username: params[:username])) != nil
      ingredients = params[:ingredients]
      ingredients.each do |ingredient|
        #If the ingredient is not already in the Ingredient table, add it
        if (ing = Ingredient.find_by(name: ingredient[1][:name])) == nil
          ing = Ingredient.create(name: ingredient[1][:name])
        end
        Own.create(users_id: user.id, ingredients_id: ing.id, weight_unit: ingredient[1][:weight_unit],
                   weight_value: ingredient[1][:weight_value], volume_unit: ingredient[1][:volume_unit], volume_value: ingredient[1][:volume_value])
      end
      render json: "Success, the ingredients were added"
    else
      render json: "Failure, the user does not exist"
    end
  end

  #Removes an ingredient from the users pantry.
  def remove_ingredient
    if pantry_ingredient = Own.find_by(users_id: User.find_by(username: params[:username]).id, ingredients_id: Ingredient.find_by(name: params[:ingredient])) != nil
      pantry_ingredient.destroy
      render "Success, ingredient removed from your pantry"
    else
      render json: "Failure, you do not have that ingredient"
    end
  end

  #Updates an ingredient in the users pantry
  def update_ingredient
    if pantry_ingredient = Own.find_by(users_id: User.find_by(username: params[:username]).id, ingredients_id: Ingredient.find_by(name: params[:ingredient])) != nil
      pantry_ingredient.update(params.permit(:weight_unit, :weight_value, :volume_unit, :volume_value))
    else
      render json: "Failure, you do not have that ingredient"
    end
  end

  def show_pantry
    if (user = User.find_by(username: params[:username])) != nil
      render json: {owns: Own.all}
    else
      render json: "Failure, user does not exist"
    end
  end



end
