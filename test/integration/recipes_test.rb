require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  test 'Should get recipes index page' do
    get recipes_url

    assert_response :success
  end
end
