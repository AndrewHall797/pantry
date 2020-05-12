class Recipe < ApplicationRecord

  has_many :contain
  has_many :ingredients, through: :contains

  belongs_to :user

  has_many :book_marks
  has_many :users, through: :book_marks

  has_many :steps

  #Adds a step into a recipe, if it has the same number as an already exising step, it displaces it and all steps after it
  def addStepIntoRecipe(recipe, step)
    steps = Step.where("recipe_id = ?", recipe.id)

    steps.each do |step|
      if step.number >= recipe
        step.update(number: (recipe.number + 1))
      end
    end

  end

  #Moves a step up or down
  def updateStepNumber(recipe, moveStep, newNum)
    steps = Step.where("recipe_id = ?", recipe.id)

    if (newStep.number - newNum) > 0
      steps.each do |step|
        if step.number >= step.number and step.number <= newNum
          step.update(number: (step.number - 1))
        end
      end
    elsif (newStep.number - newNum) < 0
      steps.each do |step|
        if step.number >= newNum and step.number <= moveStep.number
          step.update(number: (step.number + 1))
        end
      end
    end

  end

  #adds a list of ingredients to a recipe
  def addIngredients(recipe, ingredients)
    ingredients.each do |ingredient|
      if ing = Ingredient.find_by(name: ingredient[:name]) != nil
        Contain.create(ingredient_id: ing.id, recipe_id: recipe.id, weight_unit: ingredient[:weight_unit],
                       weight_value: ingredient[:weight_value], volume_unit: ingredient[:volume_unit], volume_value: ingredient[:volume_value])
      end
    end
  end

end
