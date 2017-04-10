require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef    = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                            password: 'password', password_confirmation: 'password'
  end

  test 'Should accept valid edits' do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'

    patch chef_path, params: { chef: {
      name:                  'Julian G. Nicholls',
      email:                 'julian1@example.com'
    } }

    assert_redirected_to @chef
    @chef.reload

    assert_match 'Julian G. Nicholls', @chef.name
    assert_match 'julian1@example.com', @chef.email
  end

  test 'Should reject invalid edits' do
    get edit_chef_path(@chef)

    patch chef_path, params: { chef: {
      name:                  'Anne',
      email:                 'anne@example.com'
    } }

    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
