require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com'
    @recipe1 = @chef.recipes.build name: 'Vegetable Lasagna', description: 'Fantastic vegeable lasagna'
    @recipe2 = @chef.recipes.build name: 'Chilli con Carne', description: 'Spicy Chilli with beef'

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
end
