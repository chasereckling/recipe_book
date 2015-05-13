require('spec_helper')

describe(Ingredient) do

  it('Validates presence of name.') do
    test_ingredient = Ingredient.new({:name => ""})
    expect(test_ingredient.save()).to(eq(false))
  end

  it('Capitalizes the name.') do
    test_ingredient = Ingredient.create({:name => "fried dumplings"})
    expect(test_ingredient.name).to(eq("Fried dumplings"))
  end

end
