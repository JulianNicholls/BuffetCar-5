require 'test_helper'

class ChefLoginTest < ActionDispatch::IntegrationTest
  def setup
    @chef    = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                            password: 'password', password_confirmation: 'password'
  end

  test 'Should accept valid chef credentials and start a session' do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: {
      email: @chef.email,
      password: @chef.password
    } }

    assert_redirected_to @chef
    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
    assert_not session[:chef_id].nil?

    assert_select 'a[href=?]', login_path, text: 'Log in', count: 0
    assert_select 'a[href=?]', logout_path, text: 'Log out'

    assert_select 'a[href=?]', chef_path(@chef), text: 'View'
    assert_select 'a[href=?]', edit_chef_path(@chef), text: 'Edit'
  end

  test 'Should reject unknown chef' do
    get login_path

    post login_path, params: { session: {
      email: 'noone@nowhere.com',
      password: 'irrelevant'
    } }

    assert_template 'sessions/new'
    assert_not flash.empty?
    assert session[:chef_id].nil?

    assert_select 'a[href=?]', login_path, text: 'Log in'
    assert_select 'a[href=?]', logout_path, text: 'Log out', count: 0

    # go somewhere else and ensure that the flash goes away
    get root_path
    assert flash.empty?
  end

  test 'Should reject known chef with bad password' do
    get login_path

    post login_path, params: { session: {
      email: 'julian@nowhere.com',
      password: 'incorrect'
    } }

    assert_template 'sessions/new'
    assert_not flash.empty?
    assert session[:chef_id].nil?

    assert_select 'a[href=?]', login_path, text: 'Log in'
    assert_select 'a[href=?]', logout_path, text: 'Log out', count: 0

    get root_path
    assert flash.empty?
  end

  test 'Should log out successfully' do
    get login_path

    post login_path, params: { session: {
      email: @chef.email,
      password: @chef.password
    } }

    assert_not session[:chef_id].nil?

    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash.empty?
    assert session[:chef_id].nil?
  end
end
