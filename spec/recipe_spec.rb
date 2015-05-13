require('spec_helper')

describe(Recipe) do
  it('Validates presence of name.') do
    test_recipe = Recipe.new({:name => ""})
    expect(test_recipe.save()).to(eq(false))
  end

  it('Capitalizes the name.') do
    test_recipe = Recipe.create({:name => "apple pie sandwich"})
    expect(test_recipe.name).to(eq("Apple pie sandwich"))
  end
end
