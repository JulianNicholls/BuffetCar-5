require 'test_helper'

class PagesTest < ActionDispatch::IntegrationTest
  def setup
    @chef   = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                           password: 'password', password_confirmation: 'password'
  end

  test 'Should get home page' do
    get pages_home_url
    assert_response :success
    assert_template 'pages/home'
  end

  test 'Should find correct navigation items with no user' do
    get pages_home_url

    assert_select 'a[href=?]', chefs_path, text: 'Chefs'
    assert_select 'a[href=?]', recipes_path, text: 'Recipes'

    assert_select 'a[href=?]', signup_path, text: 'Sign up'
    assert_select 'a[href=?]', login_path, text: 'Log in'

    assert_select 'a[href=?]', chef_path(@chef), text: 'View', count: 0
    assert_select 'a[href=?]', edit_chef_path(@chef), text: 'Edit', count: 0
  end

  test 'Should find correct navigation items with logged in user' do
    log_in_as @chef, @chef.password
    get pages_home_url

    follow_redirect!    # will be redirected to recipes page when logged in

    assert_select 'a[href=?]', chefs_path, text: 'Chefs'

    assert_select 'a[href=?]', recipes_path, text: 'List'
    assert_select 'a[href=?]', new_recipe_path, text: 'Add a new one'

    assert_select 'a[href=?]', signup_path, text: 'Sign up', count: 0
    assert_select 'a[href=?]', login_path, text: 'Log in', count: 0

    assert_select 'a[href=?]', chef_path(@chef), text: 'View'
    assert_select 'a[href=?]', edit_chef_path(@chef), text: 'Edit'
  end

  test 'Should get root' do
    get root_url
    assert_response :success
    assert_template 'pages/home'
  end
end
