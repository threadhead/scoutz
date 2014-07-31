module SentientUser
  extend ActiveSupport::Concern

  # store the current user in the User class' current thread
  # inspiration: https://github.com/bokmann/sentient_user/blob/master/lib/sentient_user.rb


  module ClassMethods
    def current
      Thread.current[:user]
    end
    def current=(user)
      raise(ArgumentError, "Expected an object of class '#{self}', got #{user.inspect}") unless (user.is_a?(self) || user.nil?)
      Thread.current[:user] = user
    end
  end

  def make_current
    Thread.current[:user] = self
  end
end
