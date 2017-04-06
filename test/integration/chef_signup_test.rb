require 'test_helper'

class ChefSignupTest < ActionDispatch::IntegrationTest
  test 'Should get signup_path' do
    get signup_path
    assert_response :success
  end

  test 'Should save a valid signup' do
    get signup_path

    assert_difference 'Chef.count', 1 do
      post chefs_path, params: { chef: {
        name:                  'Julian Nicholls',
        email:                 'julian@example.com',
        password:              'password',
        password_confirmation: 'password'
      } }
    end

    follow_redirect!
    assert_template 'chefs/show'
    assert_not flash.empty?
  end

  test 'Should reject an invalid signup' do
    get signup_path

    assert_no_difference 'Chef.count' do
      post chefs_path, params: { chef: {
        name: '',
        email: '',
        password: '',
        password_confirmation: ''
      } }
    end

    assert_template 'chefs/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
