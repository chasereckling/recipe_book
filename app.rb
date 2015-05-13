require("bundler/setup")
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

get('/recipes') do
  @recipes = Recipe.all()
  @message = ""
  erb(:recipes)
end

post('/recipes') do
  new_recipe = Recipe.new({:name => params.fetch('name')})
  if(new_recipe.save())
    @message = "Added recipe successfully."
  else
    @message = "ERROR: Invalid recipe name."
  end
  @recipes = Recipe.all()
  erb(:recipes)
end

get('/recipe/:id') do
  @recipe = Recipe.find(params.fetch("id").to_i())
  @ingredients = Ingredient.all()
  erb(:recipe)
end

post('/recipe/:id') do
  @recipe = Recipe.find(params.fetch("id").to_i())
  new_ingredient = Ingredient.new({:name => params.fetch('name')})
  if(new_ingredient.save())
    @message = "Added ingredient successfully."
  else
    @message = "ERROR: Invalid ingredient name."
  end
  @ingredients = Ingredient.all()
  erb(:recipe)
end
