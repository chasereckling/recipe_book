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

  it('Ensures case-insensitive uniqueness for ingredient names.') do
    test_ingredient = Ingredient.create({:name => "frIed Dumplings"})
    test_ingredient2 = Ingredient.new({:name => "frieD duMplings"})
    expect(test_ingredient2.save()).to(eq(false))
  end


end
