require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef   = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com'
    @recipe = @chef.recipes.build name: 'Vegetable Lasagna',
                                   description: 'Fantastic vegetable lasagna'

    @recipe.save
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

    follow_redirect!

    assert_match recipe_name, response.body
    assert_match recipe_desc, response.body
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
