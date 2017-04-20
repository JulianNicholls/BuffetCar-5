require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @chef    = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                            password: 'password', password_confirmation: 'password'

    @chef2    = Chef.create! name: 'Admin User', email: 'admin@nowhere.com',
                             password: 'password', password_confirmation: 'password'

    @recipe1 = @chef.recipes.create! name: 'Vegetable Lasagna',
                                     description: 'Fantastic vegetable lasagna'

    @recipe2 = @chef.recipes.create! name: 'Chilli con Carne',
                                     description: 'Spicy Chilli with beef'
  end

  test 'Should get recipes index page' do
    get recipes_url

    assert_response :success
  end

  test 'Should get recipe listing' do
    get recipes_path

    assert_template 'recipes/index'
    assert_match @recipe1.name, response.body
    assert_match @recipe2.name, response.body
  end

  test 'Recipe names should be links to show page' do
    get recipes_path

    assert_select 'a[href=?]', recipe_path(@recipe1), text: @recipe1.name
    assert_select 'a[href=?]', recipe_path(@recipe2), text: @recipe2.name
  end

  test 'show page should have necessary information with no chef logged in' do
    get recipe_path(@recipe1)
    assert_template 'recipes/show'

    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @recipe1.chef.name, response.body

    assert_select 'a[href=?]', edit_recipe_path(@recipe1),
                  text: 'Edit Recipe', count: 0
    assert_select 'a[href=?]', recipe_path(@recipe1), text: 'Delete Recipe', count: 0
    assert_select 'a[href=?]', recipes_path, text: 'Back to Recipe List'

    assert_select 'a[href=?]', chef_path(@recipe1.chef)
  end

  test 'show page should have necessary information with owning chef logged in' do
    log_in_as @chef, @chef.password
    get recipe_path(@recipe1)
    assert_template 'recipes/show'

    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @recipe1.chef.name, response.body

    assert_select 'a[href=?]', edit_recipe_path(@recipe1), text: 'Edit Recipe'
    assert_select 'a[href=?]', recipe_path(@recipe1), text: 'Delete Recipe'
    assert_select 'a[href=?]', recipes_path, text: 'Back to Recipe List'

    assert_select 'a[href=?]', chef_path(@recipe1.chef)
  end

  test 'show page should have necessary information with an admin logged in' do
    log_in_as @chef2, @chef2.password
    @chef2.toggle! :admin

    get recipe_path(@recipe1)
    assert_template 'recipes/show'

    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @recipe1.chef.name, response.body

    assert_select 'a[href=?]', edit_recipe_path(@recipe1), text: 'Edit Recipe'
    assert_select 'a[href=?]', recipe_path(@recipe1), text: 'Delete Recipe'
    assert_select 'a[href=?]', recipes_path, text: 'Back to Recipe List'

    assert_select 'a[href=?]', chef_path(@recipe1.chef)
  end
end
