require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @chef   = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                           password: 'password', password_confirmation: 'password'

    @chef2   = Chef.create! name: 'Mashrur Hossain', email: 'mashrur@nowhere.com',
                            password: 'password', password_confirmation: 'password'

    @recipe = @chef.recipes.create! name: 'Vegetable Lasagna',
                                    description: 'Fantastic vegetable lasagna'
  end

  test 'should delete a recipe' do
    log_in_as @chef, @chef.password
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: 'Delete Recipe'

    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@recipe)
    end

    assert_redirected_to recipes_path
    assert_not flash.empty?
  end

  test 'Should not allow delete when not logged in' do
    assert_difference 'Recipe.count', 0 do
      delete recipe_path(@recipe)
    end

    assert_redirected_to root_path
  end

  test 'Should not allow delete when not logged in as the recipe owner' do
    log_in_as @chef2, @chef2.password

    assert_difference 'Recipe.count', 0 do
      delete recipe_path(@recipe)
    end

    assert_redirected_to recipes_path
  end

  test 'Should allow delete by an admin' do
    log_in_as @chef2, @chef2.password
    @chef2.toggle! :admin

    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@recipe)
    end

    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
end
