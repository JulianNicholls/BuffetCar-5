require 'test_helper'

class ChefsTestTest < ActionDispatch::IntegrationTest
  def setup
    @chef1  = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                           password: 'password', password_confirmation: 'password'
    @chef2  = Chef.create! name: 'Mashrur Hossain', email: 'mashrur@nowhere.com',
                           password: 'password', password_confirmation: 'password'
  end

  test 'Should list all chefs' do
    get chefs_path
    assert_template 'chefs/index'

    assert_select 'a[href=?]', chef_path(@chef1), text: @chef1.name
    assert_select 'a[href=?]', chef_path(@chef2), text: @chef2.name

    assert_select 'a[href=?]', chef_path(@chef1), text: 'Delete Chef'
    assert_select 'a[href=?]', chef_path(@chef2), text: 'Delete Chef'
  end

  test 'Should allow delete of chef' do
    get chefs_path

    assert_difference 'Chef.count', -1 do
      delete chef_path(@chef2)
    end

    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
