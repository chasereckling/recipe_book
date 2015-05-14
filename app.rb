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
  new_ingredient_name = params.fetch('name').capitalize()

  if @recipe.ingredients.find_by(name: new_ingredient_name) != nil         # if the ingredient being added is already in the recipe...
    @message = "ERROR: Cannot add the same ingredient to a recipe twice!"  # ...return an error message and do nothing.
  else                                                                     # otherwise,
    new_ingredient = Ingredient.find_by(name: new_ingredient_name)         # if the ingredient being added...
    if new_ingredient == nil                                               # ...does not already exist...
      new_ingredient = Ingredient.new({name: new_ingredient_name})         # ...create it.
    end
    @recipe.ingredients.push(new_ingredient)                               # add the ingredient - whether preexisting or newly created - to the recipe.
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

get('/categories') do
  @message = ""
  @categories = Category.all()
  erb(:categories)
end

post('/categories') do
  new_category = Category.new({:name => params.fetch('name')})
  if(new_category.save())
    @message = "Added category successfully."
  else
    @message = "ERROR: Invalid category name."
  end
  @categories = Category.all().sort_by {|category| category.name}
  erb(:categories)
end

get('/category/:id') do
  @category = Category.find(params.fetch('id').to_i())
  # @recipes = Recipe.all() # change this later to exclude recipes already in the category
  @message = ""
  @recipes = Recipe.where.not(id: @category.recipe_ids)
  erb(:category)
end

patch('/category/:id') do
  @category = Category.find(params.fetch('id').to_i())

  @message = "ERROR: No recipes selected"

  selected_recipes = []
  if(params.has_key?('recipe_ids'))
    params.fetch('recipe_ids').each() do |recipe_id|
      @category.recipes.push(Recipe.find(recipe_id.to_i()))
    end
    @message = "Added recipe(s)"
  end

  @recipes = Recipe.where.not(id: @category.recipe_ids)
  erb(:category)
end

delete('/category/:id') do
  category = Category.find(params.fetch("id").to_i())
  category.destroy()
  @categories = Category.all()
  @message = "Deleted category."
  erb(:categories)
end
