require 'test_helper'

class RecipesNewTest < ActionDispatch::IntegrationTest
  def setup
    @chef    = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                            password: 'password', password_confirmation: 'password'
  end

  test 'Should create new valid recipe' do
    log_in_as @chef, @chef.password
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
    log_in_as @chef, @chef.password
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
