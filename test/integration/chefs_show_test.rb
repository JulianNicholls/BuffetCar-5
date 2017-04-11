require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
  def setup
    @chef    = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                            password: 'password', password_confirmation: 'password',
                            biography: 'A short description of the chef'

    @recipe1 = @chef.recipes.create! name: 'Vegetable Lasagna',
                                     description: 'Fantastic vegetable lasagna'

    @recipe2 = @chef.recipes.create! name: 'Chilli con Carne',
                                     description: 'Spicy Chilli with beef'
  end

  test 'Should show recipes for the chosen chef' do
    get chef_path(@chef)
    assert_template 'chefs/show'

    assert_match  @chef.name, response.body

    assert_select 'a[href=?]', recipe_path(@recipe1), text: @recipe1.name
    assert_select 'a[href=?]', recipe_path(@recipe2), text: @recipe2.name

    assert_match @recipe1.description, response.body
    assert_match @recipe2.description, response.body
  end

  test 'Should show biography for the chosen chef' do
    get chef_path(@chef)

    assert_match  @chef.biography, response.body
  end
end
