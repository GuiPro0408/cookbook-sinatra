require_relative "recipe"

class ScrapeAllrecipesService
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    # À FAIRE : retourner une liste de `Recipe` construites en scrapant le Web.
    doc = Nokogiri::HTML(URI.open("https://www.allrecipes.com/search/results/?search=#{@keyword}").read, nil, "utf-8")

    # Loop 5 times to get top 5
    doc.search(".card__detailsContainer").first(5).map do |element|
      # Get the title
      name = element.search(".card__title").text.strip
      # Get the description
      description = element.search(".card__summary").text.strip
      # Get the rating
      rating = element.search(".review-star-text").text.strip.split[1].to_f
      # Get the prep_time
      # Get the url recipe to enter its page
      recipe_url = element.search('.card__titleLink').attr('href') # => link of the recipe
      recipe_doc = Nokogiri::HTML(URI.open(recipe_url).read, nil, 'utf-8')
      prep_time = recipe_doc.search(".recipe-meta-item-body").text.strip.split[0].to_i # => Minutes of prep
      # Create a recipe with received infos
      Recipe.new(name, description, rating, prep_time)
    end
  end
end
