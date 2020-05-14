class Recipe < ApplicationRecord

  has_many :contain
  has_many :ingredients, through: :contains

  belongs_to :user

  has_many :book_marks
  has_many :users, through: :book_marks

  has_many :steps

  #Adds a step into a recipe, if it has the same number as an already exising step, it displaces it and all steps after it
  def self.addStepIntoRecipe(recipe, step)
    steps = Step.where("recipe_id = ?", recipe.id)

    steps.each do |step|
      if step.number >= recipe
        step.update(number: (recipe.number + 1))
      end
    end

  end

  #Moves a step up or down
  def self.updateStepNumber(recipe, moveStep, newNum)
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
  def self.addIngredients(recipe, ingredients)
    ingredients.each do |ingredient|
      if (ing = Ingredient.find_by(name: ingredient[1][:name])) == nil
        ing = Ingredient.create(name: ingredient[1][:name])
      end
      Contain.create(ingredient: ing, recipe: recipe, weight_unit: ingredient[1][:weight_unit],
                     weight_value: ingredient[1][:weight_value], volume_unit: ingredient[1][:volume_unit], volume_value: ingredient[1][:volume_value])
    end
  end

end
