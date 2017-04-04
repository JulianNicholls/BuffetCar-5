require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

  def setup
    @recipe = Recipe.new(name: 'Vegetable Lasagna', description: 'Fantastic vegeable lasagna')
  end

  test 'Recipe should be valid' do
    assert @recipe.valid?
  end

  test 'Recipe should be invalid with no name' do
    @recipe.name = ''
    assert_not @recipe.valid?
  end

  test 'Recipe should be invalid with short name (< 6)' do
    @recipe.name = 'A' * 5
    assert_not @recipe.valid?
  end

  test 'Recipe should be invalid with long name (> 50)' do
    @recipe.name = 'A' * 51
    assert_not @recipe.valid?
  end

  test 'Recipe should be invalid with no description' do
    @recipe.description = ''
    assert_not @recipe.valid?
  end

  test 'Recipe should be invalid with short description (< 12)' do
    @recipe.description = 'A' * 11
    assert_not @recipe.valid?
  end

end
