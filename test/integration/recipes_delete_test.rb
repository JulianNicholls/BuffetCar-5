require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @chef   = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com'
    @recipe = @chef.recipes.build name: 'Vegetable Lasagna',
                                   description: 'Fantastic vegetable lasagna'

    @recipe.save
  end

  test 'should delete a recipe' do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: 'Delete Recipe'

    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@recipe)
    end

    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
end
