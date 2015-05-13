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
    click_button('submit')
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
