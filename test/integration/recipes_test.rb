require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @chef    = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com'
    @recipe1 = @chef.recipes.build name: 'Vegetable Lasagna',
                                   description: 'Fantastic vegetable lasagna'
    @recipe2 = @chef.recipes.build name: 'Chilli con Carne',
                                   description: 'Spicy Chilli with beef'

    @recipe1.save
    @recipe2.save
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

  test 'show page should have necessary information' do
    get recipe_path(@recipe1)
    assert_template 'recipes/show'

    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @recipe1.chef.name, response.body

    assert_select 'a[href=?]', edit_recipe_path(@recipe1), text: 'Edit Recipe'
    assert_select 'a[href=?]', recipe_path(@recipe1), text: 'Delete Recipe'
    assert_select 'a[href=?]', recipes_path, text: 'Back to Recipe List'
  end

  test 'Should create new valid recipe' do
    get new_recipe_path

    assert_template 'recipes/new'

    recipe_name = 'Chicken Korma'
    recipe_desc = 'Stick a chicken in some coconut cream.'

    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: {
        name:        recipe_name,
        description: recipe_desc
      } }
    end

    follow_redirect!
    assert_not flash.empty?

    assert_match recipe_name, response.body
    assert_match recipe_desc, response.body
  end

  test 'Should reject invalid new recipe' do
    get new_recipe_path

    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: {
        name:        '',
        description: ''
      } }
    end

    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
