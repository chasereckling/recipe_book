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
