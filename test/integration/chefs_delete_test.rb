require 'test_helper'

class ChefsDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @chef1  = Chef.create! name: 'Julian Nicholls', email: 'julian@nowhere.com',
                           password: 'password', password_confirmation: 'password'

    @chef2  = Chef.create! name: 'Mashrur Hossain', email: 'mashrur@nowhere.com',
                           password: 'password', password_confirmation: 'password'
  end

  test 'Should not allow delete of chef by the chef' do
    log_in_as @chef2, @chef2.password
    get chefs_path

    assert_difference 'Chef.count', 0 do
      delete chef_path(@chef2)
    end

    assert_redirected_to chefs_path
  end

  test 'Should not allow delete when not logged in or logged in as another chef' do
    assert_difference 'Chef.count', 0 do    # No-one logged in
      delete chef_path(@chef2)
    end

    assert_redirected_to chefs_path

    log_in_as @chef1, @chef1.password

    assert_difference 'Chef.count', 0 do    # Other chef logged in
      delete chef_path(@chef2)
    end

    assert_redirected_to chefs_path
  end

  test 'Should allow delete of normal chef by an admin' do
    log_in_as @chef1, @chef1.password
    @chef1.toggle! :admin

    assert_difference 'Chef.count', -1 do
      delete chef_path(@chef2)
    end

    assert_redirected_to chefs_path
    assert_not flash.empty?
  end

  test 'Should not allow delete of an admin by anyone' do
    log_in_as @chef1, @chef1.password
    @chef1.toggle! :admin
    @chef2.toggle! :admin

    assert_difference 'Chef.count', 0 do
      delete chef_path(@chef2)
    end

    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
