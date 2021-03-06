require('./app')
require('spec_helper')

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe("The path to the index page", {:type => :feature}) do
  it("displays a welcome page.") do
    visit('/')
    expect(page).to(have_content('Recipe Box'))
  end
end

describe("The path to the recipes page", {:type => :feature}) do
  it("displays the list of recipes.") do
    visit('/')
    click_button('recipes')
    expect(page).to(have_content("Recipes:"))
  end
end

describe("The path to add a recipe", {:type => :feature}) do
  it("displays a form which adds a recipe to the list of recipes when submitted.") do
    visit('/')
    click_button('recipes')
    fill_in("name", :with => "Fried ear")
    click_button('add_recipe')
    expect(page).to(have_content("Fried ear"))
  end
end

describe("The path to an individual recipe's page", {:type => :feature}) do
  it("displays information about the individual recipe.") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    visit('/')
    click_button('recipes')
    click_link(test_recipe.id)
    expect(page).to(have_content("Apple pie sandwich"))
    expect(page).to(have_content("Recipe details:"))
  end
end

describe("The path to add an ingredient to a recipe", {:type => :feature}) do
  it("displays a form on the individual recipe's page that adds an ingredient to the recipe when submitted.") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    visit('/')
    click_button('recipes')
    click_link(test_recipe.id)
    fill_in('name', :with => "Apples")
    click_button('add_ingredient')
    expect(page).to(have_content("Apples"))
  end
end

describe("the path to add instructions to a recipe", {:type => :feature}) do
  it("displays a form on the recipe page to update the instructions") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    visit('/')
    click_button('recipes')
    click_link(test_recipe.id)
    fill_in('instructions', :with => "cook in the microwave")
    click_button('update_instructions')
    expect(page).to(have_content("cook in the microwave"))
  end
end

describe("the path to delete a recipe", {:type => :feature}) do
  it("displays a button on the recipe page to delete a recipe") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    visit('/')
    click_button('recipes')
    click_link(test_recipe.id)
    click_button('delete')
    expect(page).to(have_no_content("Apple pie sandwich"))
  end
end

describe("the path to rate a recipe", {:type => :feature}) do
  it("displays 5 buttons to select the rating of recipe") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    visit('/')
    click_button('recipes')
    click_link(test_recipe.id)
    choose('5')
    click_button('add_rating')
    expect(page).to(have_content("Rating: 5"))
  end
end

describe("the path to select an ingredient to see its associated recipes", {:type => :feature}) do
  it("displays a drop down menu to select an ingredient") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    test_ingredient = Ingredient.create({:name => "Apple"})
    test_recipe.ingredients.push(test_ingredient)
    visit('/')
    click_link(test_ingredient.id())
    expect(page).to(have_content('Recipes that include Apple'))
  end
end

describe("the path to select a recipe from the search results page", {:type => :feature}) do
  it("displays a list of recipes containing a specific ingredient, each of which links to that recipe's page") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    test_ingredient = Ingredient.create({:name => "Apple"})
    test_recipe.ingredients.push(test_ingredient)
    visit('/')
    click_link(test_ingredient.id)
    click_link(test_recipe.id)
    expect(page).to(have_content("Recipe details: Apple pie sandwich"))
  end
end

describe("the path to select an ingredient from the recipe page to see the other recipes it's associated with", {:type => :feature}) do
  it("displays an ingredient link for the associated recipes") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    test_ingredient = Ingredient.create({:name => "Apple"})
    test_recipe.ingredients.push(test_ingredient)
    visit('/')
    click_button('recipes')
    click_link(test_recipe.id)
    click_link(test_ingredient.id)
    expect(page).to(have_content('Recipes that include Apple'))
  end
end

describe("path to add an ingredient to recipe prevents user from adding duplicate ingredient", {:type => :feature}) do
  it("displays an error message") do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    visit('/')
    click_button('recipes')
    click_link(test_recipe.id)
    fill_in('name', :with => 'Butter')
    click_button('add_ingredient')
    fill_in('name', :with => 'Butter')
    click_button('add_ingredient')
    expect(page).to(have_content('ERROR'))
  end
end

describe("path to add the same ingredient to two different recipes", {:type => :feature}) do
  it("allows the addition of the same ingredient to two different recipes") do
    test_recipe = Recipe.create({:name => "muffin"})
    test_recipe2 = Recipe.create({:name => "bagel"})
    visit('/')
    click_button('recipes')
    click_link(test_recipe.id)
    fill_in('name', :with => 'Flour')
    click_button('add_ingredient')
    click_link('back')
    click_link(test_recipe2.id)
    fill_in('name', :with => 'Flour')
    click_button('add_ingredient')
    expect(page).to(have_content("Flour"))
  end
end

describe("path to view categories", :type => :feature) do
  it("displays a list of categories") do
    visit('/')
    click_on("categories")
    expect(page).to(have_content("Categories:"))
  end
end

describe("The path to add a category", {:type => :feature}) do
  it("displays a form which adds a category to the list of categories when submitted.") do
    visit('/')
    click_button('categories')
    fill_in("name", :with => "Russian")
    click_button('add_category')
    expect(page).to(have_content("Russian"))
  end
end

describe("path to add a recipe to a category", :type => :feature) do
  it("displays a recipe form on a category page which add a recipe to that category") do
    test_category = Category.create({:name => "Russian"})
    test_recipe = Recipe.create({:name => "muffin"})
    visit('/')
    click_button('categories')
    click_link(test_category.id)
    check(test_recipe.id)
    click_button('attach_recipes')
    expect(page).to(have_content("Muffin"))
    expect(page).to(have_content("Added recipe(s)"))
  end
end

describe("path to delete a category", {:type => :feature}) do
  it("displays a button on a category's page to delete the category and return to the list of categories.") do
    test_category = Category.create({:name => "Russian"})
    visit('/')
    click_button('categories')
    click_link(test_category.id)
    click_button('delete')
    expect(page).to(have_content("Deleted category."))
    expect(page).to(have_no_content(test_category.name))
  end
end
