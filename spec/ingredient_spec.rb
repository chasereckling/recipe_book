require('spec_helper')

describe(Ingredient) do

  it('Validates presence of name.') do
    test_ingredient = Ingredient.new({:name => ""})
    expect(test_ingredient.save()).to(eq(false))
  end

end
