require 'test_helper'

class PagesTest < ActionDispatch::IntegrationTest
  test 'Should get home page' do
    get pages_home_url
    assert_response :success
    assert_template 'pages/home'
  end

  test 'Should find correct navigation items' do
    get pages_home_url

    assert_select 'a[href=?]', chefs_path, text: 'Chefs'
    assert_select 'a[href=?]', signup_path, text: 'Sign up'

    assert_select 'a[href=?]', recipes_path, text: 'List'
    assert_select 'a[href=?]', new_recipe_path, text: 'Add a new one'
  end

  test 'Should get root' do
    get root_url
    assert_response :success
    assert_template 'pages/home'
  end
end
