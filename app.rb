require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'recipe'
require_relative 'cookbook'
require_relative 'scraper_service'
require 'nokogiri'
require 'open-uri'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

# Create a repo
cookbook = Cookbook.new(File.join(__dir__, "recipes.csv"))

get "/" do
  # Return an array of cookbook
  @recipes = cookbook.all
  erb :index
end

get "/new" do
  erb :create
end

get "/scraper" do
  erb :scraper
end

post '/scraping' do
  # Scraping recipes
  @scrapered_recipes = ScrapeAllrecipesService.new(params[:ingredient]).call
  erb :scrapered
end

# post get the action to create by /recipes
post '/recipes' do
  # create a recipe by the gathered infos
  @recipe = Recipe.new(params[:recipe_name], params[:recipe_description], params[:recipe_rating], params[:recipe_prep])
  # Add it to cookbook
  cookbook.add_recipe(@recipe)
  redirect "/"
end

get "/recipes/:index" do
  # Remove to cookbook
  cookbook.remove_recipe(params[:index].to_i)
  redirect "/"
end

get "/mark/:index" do
  # Remove to cookbook
  cookbook.mark_the_recipe_as_done(params[:index].to_i)
  redirect "/"
end
