class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name, :address1, :address2, :city, :state, :zip_code, :time_zone

  validates_presence_of :first_name, :last_name

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


  has_and_belongs_to_many :organizations
  has_many :phones
  has_many :notifiers, dependent: :destroy
  has_and_belongs_to_many :events

  before_save :ensure_authentication_token

  def full_name
    "#{first_name} #{last_name}"
  end
end
