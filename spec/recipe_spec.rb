require('spec_helper')

describe(Recipe) do
  it('Validates presence of name.') do
    test_recipe = Recipe.new({:name => ""})
    expect(test_recipe.save()).to(eq(false))
  end
end
