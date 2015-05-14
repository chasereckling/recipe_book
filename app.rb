require("bundler/setup")
Bundler.require(:default, :test)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  erb(:index)
end

get('/recipes') do
  @recipes = Recipe.all().sort_by {|recipe| recipe.rating}
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
  @recipes = Recipe.all().sort_by {|recipe| recipe.rating}
  erb(:recipes)
end

get('/recipe/:id') do
  @recipe = Recipe.find(params.fetch("id").to_i())
  @ingredients = @recipe.ingredients()
  erb(:recipe)
end

post('/recipe/:id') do
  @recipe = Recipe.find(params.fetch("id").to_i())
  new_ingredient_name = params.fetch('name')
  new_ingredient = Ingredient.new({:name => new_ingredient_name})

  # binding.pry

  begin
    new_ingredient.save!()
  rescue ActiveRecord::RecordInvalid => error
    if(@recipe.ingredients.find_by(name: new_ingredient_name) != nil)
      @message = "ERROR: Ingredient already exists."
    else
      new_ingredient = Ingredient.find_by(name: new_ingredient_name)
    end
  end

  if(@message == nil)
    @recipe.ingredients.push(new_ingredient)
    @message = "Added ingredient."
  end

  @ingredients = @recipe.ingredients()
  erb(:recipe)
end

patch('/recipe/:id') do
  @recipe = Recipe.find(params.fetch("id").to_i())
  @recipe.update({:instructions => params.fetch("instructions")})
  @message = "Updated instructions."
  @ingredients = @recipe.ingredients()
  erb(:recipe)
end

delete('/recipe/:id') do
  recipe = Recipe.find(params.fetch("id").to_i())
  recipe.destroy()
  @recipes = Recipe.all().sort_by {|recipe| recipe.rating}
  @message = "Deleted recipe."
  erb(:recipes)
end

patch('/recipe/:id/rating') do
  @recipe = Recipe.find(params.fetch("id").to_i())
  @recipe.update({:rating => params.fetch("rating").to_i()})
  @message = "Updated rating."
  @ingredients = @recipe.ingredients()
  erb(:recipe)
end

get('/ingredient/:id') do
  @ingredient = Ingredient.find(params.fetch("id").to_i())
  @recipes = @ingredient.recipes
  erb(:ingredient)
end
