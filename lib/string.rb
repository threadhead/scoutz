# class String
#   def commaize(after=true)
#     self.blank? ? '' : after ? "#{self}, " : ", #{self}"
#   end
# end


# from: https://github.com/bclubb/possessive/blob/master/lib/possessive.rb
class String
  def possessive
    return self if self.empty?
    self + ('s' == self[-1,1] ? Possessive::APOSTROPHE_CHAR : Possessive::APOSTROPHE_CHAR+"s")
  end
end

module Possessive
  APOSTROPHE_CHAR = '’'
end
