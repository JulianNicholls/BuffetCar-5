require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef   = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                           password: 'password', password_confirmation: 'password'

    @chef2   = Chef.create! name: 'Mashrur Hossain', email: 'mashrur@nowhere.com',
                            password: 'password', password_confirmation: 'password'

    @recipe = @chef.recipes.create! name: 'Vegetable Lasagna',
                                    description: 'Fantastic vegetable lasagna'
  end

  test 'Should successfully edit a recipe' do
    log_in_as @chef, @chef.password
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

  test 'Should reject invalid recipe update' do
    log_in_as @chef, @chef.password
    get edit_recipe_path(@recipe)

    patch recipe_path(@recipe), params: { recipe: {
      name: '',
      description: 'enough description'
    } }

    assert_template 'recipes/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test 'Should not allow edit when not logged in' do
    get edit_recipe_path(@recipe)
    assert_redirected_to root_path

    patch recipe_path(@recipe), params: { recipe: {
      name: 'new name',
      description: 'new desciption'
    } }
    assert_redirected_to root_path
  end

  test 'Should not allow edit when not recipe owner' do
    log_in_as @chef2, @chef2.password
    get edit_recipe_path(@recipe)
    assert_redirected_to recipes_path

    patch recipe_path(@recipe), params: { recipe: {
      name: 'new name',
      description: 'new desciption'
    } }
    assert_redirected_to recipes_path
  end

  test 'Should allow edits by an admin' do
    log_in_as @chef2, @chef2.password
    @chef2.toggle! :admin

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
end
