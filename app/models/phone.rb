class Phone < ActiveRecord::Base
  belongs_to :user, touch: true

  enum kind: %w(home mobile work other other2 other3)


  validates :kind, presence: true, uniqueness: { scope: :user_id }
  validates :number, presence: true, uniqueness: { scope: :user_id }


  def number=(phonenumber)
    return if phonenumber.nil?
    write_attribute(:number, phonenumber.gsub(/\D/, ''))
  end
end
