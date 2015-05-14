class Ingredient < ActiveRecord::Base
  has_and_belongs_to_many(:recipes)
  before_validation(:capitalize_name)
  validates(:name, :presence => true, :uniqueness => true)
end

private

define_method(:capitalize_name) do
  self.name.capitalize!()
end
