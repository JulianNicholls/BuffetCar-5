require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef   = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                           password: 'password', password_confirmation: 'password'

    @chef2  = Chef.create! name: 'Mashrur Hossain', email: 'mashrur@nowhere.com',
                           password: 'password', password_confirmation: 'password'

    @admin  = Chef.create! name: 'Admin Usert', email: 'admin@nowhere.com',
                           password: 'password', password_confirmation: 'password',
                           admin: true
  end

  test 'Should accept valid edits' do
    log_in_as @chef, @chef.password
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'

    patch chef_path, params: { chef: {
      name:       'Julian G. Nicholls',
      email:      'julian1@example.com',
      biography:  'This is a short description of the chef'
    } }

    assert_redirected_to @chef

    @chef.reload
    assert_match 'Julian G. Nicholls', @chef.name
    assert_match 'julian1@example.com', @chef.email
  end

  test 'Should reject invalid edits' do
    log_in_as @chef, @chef.password
    get edit_chef_path(@chef)

    patch chef_path, params: { chef: {
      name:   'Anne',               # too short
      email:  'anne@example.com'
    } }

    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'

    @chef.reload
    assert_match 'Julian Nicholls', @chef.name
    assert_match 'julian@nowhere.com', @chef.email
  end

  test 'Should not allow edits when not logged in' do
    get edit_chef_path(@chef)
    assert_redirected_to chefs_path

    patch chef_path, params: { chef: {
      name:   'Julian G. Nicholls',
      email:  'julian1@example.com'
    } }
    assert_redirected_to chefs_path

    @chef.reload
    assert_match 'Julian Nicholls', @chef.name
    assert_match 'julian@nowhere.com', @chef.email
  end

  test 'Should not allow edits by other users' do
    log_in_as @chef2, @chef2.password

    get edit_chef_path(@chef)
    assert_redirected_to chefs_path

    patch chef_path, params: { chef: {
      name:   'Julian G. Nicholls',
      email:  'julian1@example.com'
    } }
    assert_redirected_to chefs_path

    @chef.reload
    assert_match 'Julian Nicholls', @chef.name
    assert_match 'julian@nowhere.com', @chef.email
  end

  test 'Should allow edits by an admin user' do
    log_in_as @admin, @admin.password

    get edit_chef_path(@chef)

    patch chef_path, params: { chef: {
      name:   'Julian F. Nicholls',
      email:  'julian2@example.com'
    } }

    assert_redirected_to @chef

    @chef.reload
    assert_match 'Julian F. Nicholls', @chef.name
    assert_match 'julian2@example.com', @chef.email
  end
end
