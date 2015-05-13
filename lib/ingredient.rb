class Ingredient < ActiveRecord::Base
  has_and_belongs_to_many(:recipes)
  validates(:name, :presence => true)
  before_save(:capitalize_name)
end

private

define_method(:capitalize_name) do
  self.name.capitalize!()
end
