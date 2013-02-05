class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable, :validatable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :address1, :address2, :city, :state, :zip_code, :time_zone

  validates_presence_of :first_name, :last_name

  before_validation :strip_password_if_empty
  def strip_password_if_empty
    if email.blank? || password.blank?
      # puts 'setting password/confirmation to nil'
      password = nil
      password_confirmation = nil
    end
  end

  # don't use Devise validations
  # validates_presence_of   :email, if: :email_required?
  # validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  # validates_format_of     :email, with: Devise.email_regexp, allow_blank: true, if: :email_changed?

  validates :email, presence: true, uniqueness: true, unless: :email_blank? #, if: :email_required?
  def email_blank?
    email.blank?
  end
  validates :email, format: Devise.email_regexp, allow_blank: true, if: :email_changed?

  # validates_presence_of     :password, allow_blank: true, if: :password_required?
  # validates_confirmation_of :password, if: :password_required?
  validates :password, allow_blank: true, confirmation: true, if: :password_required?
  validates :password, length: Devise.password_length, allow_blank: true
  # validates_length_of       :password, within: Devise.password_length, allow_blank: true


  has_many     :parent_child_relationships,
               :class_name            => "UserRelationship",
               :foreign_key           => :child_id,
               :dependent             => :destroy
  has_many     :parents,
               :through               => :parent_child_relationships,
               :source                => :parent

  has_many     :child_parent_relationships,
               :class_name            => "UserRelationship",
               :foreign_key           => :parent_id,
               :dependent             => :destroy
  has_many     :children,
               :through               => :child_parent_relationships,
               :source                => :child


  has_and_belongs_to_many :organizations
  has_many :phones
  has_many :notifiers, dependent: :destroy
  has_and_belongs_to_many :events

  before_save :ensure_authentication_token

  def full_name
    "#{first_name} #{last_name}"
  end

  protected
    # from https://github.com/plataformatec/devise/blob/master/lib/devise/models/validatable.rb
    # Checks whether a password is needed or not. For validations only.
    # Passwords are always required if it's a new record, or if the password
    # or confirmation are being set somewhere.
    def password_required?
      # puts "persisted: #{persisted?}"
      # puts "password.nil?: #{password.nil?}"
      # puts "password_confirmation.nil?: #{password_confirmation.nil?}"
      return false if email.blank?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end

    def email_required?
      false
    end
    # end Devise

end
