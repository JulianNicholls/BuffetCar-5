require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(name: 'Julian Nicholls', email: 'julian@nowhere.com')
  end

  test 'Chef should be valid' do
    assert @chef.valid?
  end

  test 'Chef should be invalid with no name' do
    @chef.name = ''
    assert_not @chef.valid?
  end

  test 'Chef should be invalid with short name (< 5)' do
    @chef.name = 'A' * 4
    assert_not @chef.valid?
  end

  test 'Chef should be invalid with long name (> 60)' do
    @chef.name = 'A' * 61
    assert_not @chef.valid?
  end

  test 'Chef should be invalid with no email' do
    @chef.email = ''
    assert_not @chef.valid?
  end

  test 'Chef should be invalid with short email (< 8)' do
    @chef.email = 'A' * 7
    assert_not @chef.valid?
  end

  test 'Chef should be valid with valid email addresses' do
    valids = %w[julian@ok.org julian.nicholls@dotsok.org na@co.us julian+spam@test.org minus-char@test.org.uk]

    valids.each do |email|
      @chef.email = email
      assert @chef.valid?, "#{email.inspect} should be valid."
    end
  end

  test 'Chef should be invalid with invalid email addresses' do
    invalids = %w[julian@ n%s@co.us julian+spam minus-char@test julian@invalid,com julian@test.]

    invalids.each do |email|
      @chef.email = email
      assert_not @chef.valid?, "#{email.inspect} should be invalid."
    end
  end

  test 'Chefs must have unique email addresses' do
    @duplicate_chef = @chef.dup
    @duplicate_chef.email.upcase!

    @chef.save
    assert_not @duplicate_chef.valid?
  end

  test 'Chefs should have lower-case email addresses' do
    mixed_email = 'John@Capital.Com'

    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.email
  end

end
