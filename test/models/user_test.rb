# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should return name when name is present' do
    user = users(:alice)
    assert_equal 'Alice', user.name_or_email
  end

  test 'should return email when name is blank' do
    user = User.new(name: '', email: 'carol@example.com')
    assert_equal 'carol@example.com', user.name_or_email
  end
end
