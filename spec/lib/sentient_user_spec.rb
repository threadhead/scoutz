require 'rails_helper'

class Person
  include SentientUser
end

class User
  include SentientUser
end

class AnonymousUser < User; end

RSpec.describe 'SentientUser' do
  it 'allow a Person to be sentient' do
    p = Person.new
    p.make_current
    expect(Person.current).to eq(p)
  end

  it 'allow a User to be sentient' do
    u = User.new
    u.make_current
    expect(User.current).to eq(u)
  end

  it "shouldn't allow a Person.current to be a User" do
    expect{ Person.current = User.new }.to raise_error(ArgumentError)
  end

  it "allows subclasses of a SentientUser to be assigned to current" do
    expect{ User.current = AnonymousUser.new }.to_not raise_error
  end

end
