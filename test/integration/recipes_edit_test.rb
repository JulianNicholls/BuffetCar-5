require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef   = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                           password: 'password', password_confirmation: 'password'
    @recipe = @chef.recipes.create! name: 'Vegetable Lasagna',
                                    description: 'Fantastic vegetable lasagna'
  end

  test 'Successfully edit a recipe' do
    get edit_recipe_path(@recipe)

    assert_template 'recipes/edit'

    recipe_name = 'Updated Lasagna'
    recipe_desc = 'More fantastic vegetable lasagna.'

    patch recipe_path(@recipe), params: { recipe: {
      name: recipe_name,
      description: recipe_desc
    } }

    assert_redirected_to @recipe
    assert_not flash.empty?

    @recipe.reload
    assert_match recipe_name, @recipe.name
    assert_match recipe_desc, @recipe.description
  end

  test 'Reject invalid recipe update' do
    get edit_recipe_path(@recipe)

    patch recipe_path(@recipe), params: { recipe: {
      name: '',
      description: 'enough description'
    } }

    assert_template 'recipes/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

end
