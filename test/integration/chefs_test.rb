require 'test_helper'

class ChefsTest < ActionDispatch::IntegrationTest
  def setup
    @chef1  = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                           password: 'password', password_confirmation: 'password'

    @chef2  = Chef.create! name: 'Mashrur Hossain', email: 'mashrur@nowhere.com',
                           password: 'password', password_confirmation: 'password'

    @admin  = Chef.create! name: 'Admin Usert', email: 'admin@nowhere.com',
                           password: 'password', password_confirmation: 'password',
                           admin: true
  end

  test 'Should list all chefs with no-one logged in' do
    get chefs_path
    assert_template 'chefs/index'

    assert_select 'a[href=?]', chef_path(@chef1), text: @chef1.name
    assert_select 'a[href=?]', chef_path(@chef2), text: @chef2.name
    assert_select 'a[href=?]', chef_path(@admin), text: @admin.name

    assert_select 'a[href=?]', chef_path(@chef1), text: 'Delete Chef', count: 0
    assert_select 'a[href=?]', chef_path(@chef2), text: 'Delete Chef', count: 0
    assert_select 'a[href=?]', chef_path(@admin), text: 'Delete Chef', count: 0
  end

  test 'Should list all chefs to a logged in chef' do
    log_in_as @chef1, @chef1.password
    get chefs_path
    assert_template 'chefs/index'

    assert_select 'a[href=?]', chef_path(@chef1), text: @chef1.name
    assert_select 'a[href=?]', chef_path(@chef2), text: @chef2.name
    assert_select 'a[href=?]', chef_path(@admin), text: @admin.name

    assert_select 'a[href=?]', chef_path(@chef1), text: 'Delete Chef', count: 0
    assert_select 'a[href=?]', chef_path(@chef2), text: 'Delete Chef', count: 0
    assert_select 'a[href=?]', chef_path(@admin), text: 'Delete Chef', count: 0
  end

  test 'Should list all chefs with delete options, only for other chefs, to an admin' do
    log_in_as @admin, @admin.password

    get chefs_path
    assert_template 'chefs/index'

    assert_select 'a[href=?]', chef_path(@chef1), text: @chef1.name
    assert_select 'a[href=?]', chef_path(@chef2), text: @chef2.name
    assert_select 'a[href=?]', chef_path(@admin), text: @admin.name

    assert_select 'a[href=?]', chef_path(@chef1), text: 'Delete Chef'
    assert_select 'a[href=?]', chef_path(@chef2), text: 'Delete Chef'
    assert_select 'a[href=?]', chef_path(@admin), text: 'Delete Chef', count: 0
  end
end
