require('spec_helper')

describe(Category) do

  it('Validates presence of name.') do
    test_category = Category.new({:name => ""})
    expect(test_category.save()).to(eq(false))
  end

end
