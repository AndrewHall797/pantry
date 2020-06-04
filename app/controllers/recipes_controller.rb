class RecipesController < ApplicationController

  #Create a recipe, need to list the recipe items and the ingredients in the recipe
  def create
    recipeInfo = params[:recipe]
    if (recipe = Recipe.create(user: User.find_by(username: params[:username]), name: recipeInfo[:name], time: recipeInfo[:time], public: recipeInfo[:public])) != nil
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
      recipe.update(params.require(:recipe).permit(:name, :time, :public))
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
    recipeInfo = params[:recipe]
    recipe = Recipe.new(user: User.find_by(username: params[:username]), name: recipeInfo[:name], time: recipeInfo[:time], public: recipeInfo[:public])
    if recipe.save
      #Add ingredients
      ingredients = params[:ingredients]
      Recipe.addIngredients(recipe, ingredients)

      #Add steps
      steps = params[:steps]
      steps.each do |step|
        puts step
        Step.create(description: step[1][:description],number: step[1][:number])
      end
      render json: "Success"
    else
      render json: "Failure"
    end
  end

  #adds an ingredient to the recipe
  def add_ingredients
    if (recipe = Recipe.find_by(id: params[:recipe_id])) != nil
      ingredients = params[:ingredients]
      ingredients.each do |ingredient|
        #If the ingredient is not already in the Ingredient table, add it
        if (ing = Ingredient.find_by(name: params[:name])) == nil
          ing = Ingredient.create(name: params[:name])
        end
        contain = Contain.create(recipe: recipe, ingredient: ing, weight_unit: ingredient[1][:weight_unit],
                   weight_value: ingredient[1][:weight_value], volume_unit: ingredient[1][:volume_unit], volume_value: ingredient[1][:volume_value])
      end
      render json: "Success, the ingredients were added"
    else
      render json: "Failure, the recipe does not exist"
    end
  end

  #removes and ingredient from the recipe
  def remove_ingredient
    if (ingredient = Contain.find_by(recipe_id: params[:recipe_id], ingredient_id: (Ingredient.find_by(name: params[:name])).id)) == nil
      render json: "Failure, the recipe does not have that ingredient"
    end
    ingredient.destroy
    if ingredient.destroyed?
      render json: "Success, Ingredient removed"
    else
      render json: "Failure, ingredient not destroyed"
    end
  end

  #Adds a step to a recipe
  def add_step
    if (recipe = Recipe.find_by(id: params[:recipe_id])) != nil
      stepInfo = params[:step]
      step = Step.create(description: stepInfo[:description], number: stepInfo[:number], recipe: recipe)
      Recipe.addStepIntoRecipe(recipe, step)
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
