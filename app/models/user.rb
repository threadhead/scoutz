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
  attr_accessible :birth, :rank, :leadership_position, :additional_leadership_positions, :sub_unit_id, :send_reminders
  attr_accessible :adult_ids, :scout_ids

  validates_presence_of :first_name, :last_name

  before_validation :strip_password_if_empty
  def strip_password_if_empty
    self.email = nil if email.blank?
    if email.blank? || password.blank?
      self.password = nil
      self.password_confirmation = nil
      self.skip_confirmation!
    end
  end

  # don't use Devise validations
  # validates_presence_of   :email, if: :email_required?
  # validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  # validates_format_of     :email, with: Devise.email_regexp, allow_blank: true, if: :email_changed?

  # validates_presence_of     :password, allow_blank: true, if: :password_required?
  # validates_confirmation_of :password, if: :password_required?
  # validates_length_of       :password, within: Devise.password_length, allow_blank: true

  # rails-4-ify the validations to allow for blank passwords and emails
  validates :email, presence: true, uniqueness: true, unless: :email_blank?
  def email_blank?
    email.blank?
  end
  validates :email, format: Devise.email_regexp, allow_blank: true, if: :email_changed?

  validates :password, allow_blank: true, confirmation: true, if: :password_required?
  validates :password, length: Devise.password_length, allow_blank: true


  has_many     :adult_scout_relationships,
               :class_name            => "UserRelationship",
               :foreign_key           => :scout_id,
               :dependent             => :destroy
  has_many     :adults,
               :through               => :adult_scout_relationships,
               :source                => :adult

  has_many     :scout_adult_relationships,
               :class_name            => "UserRelationship",
               :foreign_key           => :adult_id,
               :dependent             => :destroy
  has_many     :scouts,
               :through               => :scout_adult_relationships,
               :source                => :scout


  has_and_belongs_to_many :units
  has_many :phones
  has_many :notifiers, dependent: :destroy
  has_and_belongs_to_many :events
  belongs_to :sub_unit
  has_many :email_messages

  before_save :ensure_authentication_token

  def name
    full_name
  end

  def name_email
    "#{full_name} <#{email}>"
  end

  # def scout_ids(unit=nil)
  #   scouts = self.scouts.select('"users"."id"')
  #   scouts = scouts.joins(:units).where(units: {id: unit}) if unit
  #   return scouts.to_a
  # end

  def full_name
    "#{first_name} #{last_name}"
  end

  def name_lf
    "#{last_name}, #{first_name}"
  end

  def age
    if birth
      now = Time.now.utc.to_date
      now.year - birth.year - ((now.month > birth.month || (now.month == birth.month && now.day >= birth.day)) ? 0 : 1)
    end
  end

  def is_a_scout?
    type == 'Scout'
  end

  def is_an_adult?
    type == 'Adult'
  end



  ## scopes
  def self.by_name_lf
    order('"users"."last_name" ASC, "users"."first_name" ASC')
  end

  def self.with_email
    where('"users"."email" IS NOT NULL')
  end

  def self.leaders
    where('"users"."leadership_position" IS NOT NULL OR "users"."additional_leadership_positions" IS NOT NULL')
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
