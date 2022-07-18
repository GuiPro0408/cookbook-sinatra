# Model qui sert a creer la recette

class Recipe
  attr_reader :name, :description, :rating, :prep_time, :done

  def initialize(name, description, rating, prep_time, done = false)
    @name = name
    @description = description
    @rating = rating
    @prep_time = prep_time
    @done = done
  end

  def mark_as_done!
    @done = true
  end
end
