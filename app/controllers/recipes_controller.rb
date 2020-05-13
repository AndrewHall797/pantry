class RecipesController < ApplicationController

  #Create a recipe
  def create
    recipe = Recipe.new(params.require(:recipe).permit(:name, :time, :public), user_id: (User.find_by(username: params[:username])).id)

    if recipe.save
      ingredients = params[:ingredients]
      Recipe.addIngredients(recipe, ingredients)
      render json: "Success, new recipe created"
    else
      render json: "Failure, new recipe not created"
    end
  end

  #Get all the recipes/ temporary as it does not enforce the public option
  def index
    render json: {recipes: Recipe.all}
  end

  def update
    if (recipe = Recipe.find_by(id: params[:recipe_id])) != nil
      recipe.update(name: params[:name], time: params[:time], public: params[:public])
      render json: "Success, recipe was updated"
    else
      render json: "Failure, the recipe does not exist"
    end
  end

  def destroy
    if (recipe = Recipe.find_by(id: params[:recipe_id])) != nil
      recipe.destroy
      render json: "Success, the recipe was deleted"
    else
      render json: "Failure, the recipe does not exist"
    end
  end

  def create_with_steps
    recipe = Recipe.new(params.require(:recipe).permit(:name, :time, :public), user_id: (User.find_by(username: params[:username])).id)
    if recipe.save
      #Add ingredients
      ingredients = params[:ingredients]
      Recipe.addIngredients(recipe, ingredients)

      #Add steps
      steps = params[:steps]
      steps.each do |step|
        Step.create(step)
      end
      render json: "Success"
    else
      render json: "Failure"
    end
  end

  #adds an ingredient to the recipe
  def add_ingredient
    if (recipe = Recipe.find_by(id: params[:recipe_id])) != nil
      if (ingredient = Ingredient.find_by(name: params[:name])) == nil
        ingredient = Ingredient.create(name: params[:name])
      end
      Contain.create(params.permit(:weight_unit, :weight_value, :volume_unit, :volume_value), ingredient_id: ingredient.id, recipe_id: recipe.id)
      render json: "Success, ingredient was added"
    else
      render json: "Failure, recipe does not exist"
    end
  end

  #removes and ingredient from the recipe
  def remove_ingredient
    if (ingredient = Contain.find_by(recipe_id: params[:recipe_id], ingredient_id: (Ingredient.find_by(name: params[:name])).id)) != nil
      ingredient.destroy
      render json: "Success, Ingredient removed"
    else
      render json: "Failure, the recipe does not have that ingredient"
    end
  end

  #Adds a step to a recipe
  def add_step
    if (recipe = Recipe.find_by(id: params[:recipe_id])) != nil
      step = Step.new(params.require(:step).permit(:description, :number, :recipe_id))
      Recipe.addStep(recipe, step)
      render json: "Success, step added"
    else
      render json: "Failure, recipe does not exist"
    end
  end

  #Sends back all the recipes the user created
  def created_recipes
    if (user = User.find_by(username: params[:username])) != nil
      render json: {created_recipes: User.joins(:recipes).select(:name, :time, :id)}
    else
      render json: "Failure, the user does not exist"
    end
  end

  #Sends back all the recipes the user bookmarked
  def bookmarked_recipes
    if (user = User.find_by(username: params[:username])) != nil
      render json: {book_marked: Book_mark.joins(:users, :recipes).select(:name, :time, :recipe_id)}
    else
      render json: "Failure, the user does not exist"
    end
  end

  #Bookmarks the recipe for the user
  def bookmark
    if Bookmark.create(user_id: (User.find_by(username: params[:username])).id, recipe_id: params[:recipe_id]) != nil
      render json: "Success, bookmared recipe"
    else
      render json: "Failure, recipe not bookmarked"
    end
  end

  #Update a step in the recipe
  def update_step_description
    if (step = Step.find_by(id: params[:step_id])) != nil
      step.update(description: params[:description])
      render json: "Success, step updated"
    else
      render json: "Failure, step does not exist"
    end
  end

  def update_step_number
    if (recipe = Recipe.find_by(id: params[:recipe_id])) != nil and movedStep = Step.find_by(id: params[:step_id]) != nil
      Recipe.updateStepNumber(recipe, movedStep, params[:number])
      render json: "Success, the steps number was updated"
    else
      render json: "Failure, could not update the number"
    end
  end

  #Get the recipe info and the steps
  def get_recipe_and_steps
    if (recipe = Recipe.find_by(id: params[:recipe_id])) != nil
      render json:{recipe: recipe, steps: Step.where("recipe_id = ?", recipe.id) }
    else
      render json: "Failure, recipe does not exist"
    end
  end

end
