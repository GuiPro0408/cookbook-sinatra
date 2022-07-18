require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file)
    @recipes = [] # Array of recipe instances => [Recipe.new(name, description), ...]
    @csv_file = csv_file
    load_data_from_csv # Load the csv file in the @recipes
  end

  # 1. List recipes
  def all
    return @recipes
  end

  # 2. add a recipe
  def add_recipe(recipe)
    @recipes << recipe
    store_data_to_csv # Save it in the CSV File
  end

  # 3. delete a recipe
  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    store_data_to_csv # Save it in the CSV File
  end

  # 4. mark a recipe as done
  def mark_the_recipe_as_done(index)
    recipe = @recipes[index]
    recipe.mark_as_done!
    store_data_to_csv # Save it in the CSV File
  end

  private

  ## Stock the CSV File in Recipes instance
  def load_data_from_csv
    CSV.foreach(@csv_file) do |row|
      # Load name thats found in first column
      name = row[0]
      # Load description thats found in second column
      description = row[1]
      # Load rating thats found in third column
      rating = row[2].to_f
      # Load prepepartion's time thats found in forth column
      prep_time = row[3]
      # Load if recipe done thats found in fifth column
      done = row[4]
      # Create a new recipe cause we need to stcok the info in the recipes instance
      recipe = Recipe.new(name, description, rating, prep_time, done)
      # stock it in ruby memory
      @recipes << recipe
    end
  end

  ## Stock the Recipes intance recipe in the CSV File
  def store_data_to_csv
    CSV.open(@csv_file, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time, recipe.done]
      end
    end
  end
end
