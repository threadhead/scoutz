class User < ActiveRecord::Base
  include SmsNumber
  include SentientUser
  include PgSearch
  include Deactivatable


  mount_uploader :picture, PictureUploader

  # Include default devise modules. Others available are:
  # :confirmable,
  # :lockable, :timeoutable and :omniauthable, :validatable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :lockable, :timeoutable


  enum role: { inactive: 0, basic: 10, leader: 20, admin: 30 }

  # don't use Devise validations
  # validates_presence_of   :email, if: :email_required?
  # validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
  # validates_format_of     :email, with: Devise.email_regexp, allow_blank: true, if: :email_changed?

  # validates_presence_of     :password, allow_blank: true, if: :password_required?
  # validates_confirmation_of :password, if: :password_required?
  # validates_length_of       :password, within: Devise.password_length, allow_blank: true

  # rails-4-ify the validations to allow for blank passwords and emails
  validates :email, presence: { allow_blank: true }, uniqueness: { allow_blank: true }
  # validates :email, format: Devise.email_regexp, allow_blank: true, if: :email_changed?

  validates :password, allow_blank: true, confirmation: true, if: :password_required?
  validates :password, length: Devise.password_length, allow_blank: true
  validates :first_name, :last_name, presence: true
  validates :sl_profile, uniqueness: { allow_nil: true }

  # validates :picture, file_size: { maximum: 0.3.megabytes.to_i, message: 'should be less than 300K' }, if: "picture.present?"
  validate :image_size_validation, if: 'picture.present?'
  def image_size_validation
    return unless picture.file.exists?
    errors.add(:picture, 'should be less than 300K') if picture.size > 0.3.megabytes.to_i
  end



  has_and_belongs_to_many :units
  has_many :notifiers, dependent: :destroy
  has_and_belongs_to_many :events, -> { uniq }
  belongs_to :sub_unit, touch: true
  has_many :email_messages, dependent: :destroy
  has_many :sms_messages, dependent: :destroy
  has_many :pages

  has_many :health_forms, inverse_of: :user, dependent: :destroy do
    def unit(unit_id)
      where(health_forms: { unit_id: unit_id }).first
    end
  end
  accepts_nested_attributes_for :health_forms


  has_many :counselors, inverse_of: :user, dependent: :destroy, autosave: true do
    def unit(unit_id)
      where(counselors: { unit_id: unit_id })
    end
  end
  has_many :merit_badges, through: :counselors, autosave: true do
    def unit(unit_id)
      where(counselors: { unit_id: unit_id })
    end
  end
  accepts_nested_attributes_for :counselors,
                                reject_if: proc { |att| att['merit_badge_id'].blank? || att['merit_badge_id'] == '0' },
                                allow_destroy: true


  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true, reject_if: proc { |a| a['number'].blank? }


  has_many :unit_positions, inverse_of: :user, dependent: :destroy do
    def unit(unit_id)
      where(unit_positions: { unit_id: unit_id }).first
    end
  end
  accepts_nested_attributes_for :unit_positions




  before_validation :strip_password_if_empty
  def strip_password_if_empty
    self.email = nil if email.blank?
    if email.blank? || password.blank?
      self.password = nil
      self.password_confirmation = nil
      self.skip_confirmation!
    end
  end



  # this may help: http://stackoverflow.com/questions/15056000/rails-habtm-self-join-error
  has_and_belongs_to_many :scouts, class_name: 'User', join_table: 'user_relationships', foreign_key: 'adult_id', association_foreign_key: 'scout_id', after_add: :touch_updated_at, after_remove: :touch_updated_at
  has_and_belongs_to_many :adults, class_name: 'User', join_table: 'user_relationships', foreign_key: 'scout_id', association_foreign_key: 'adult_id', after_add: :touch_updated_at, after_remove: :touch_updated_at

  def touch_updated_at(user)
    # logger.info "TOUCH_UPDATED_AT, self: #{self.name}, user: #{user.name}"
    user.update_column(:updated_at, Time.now)
  end
  #
  # For caching purposes, we need to touch all associated users on updates or destroy.
  # BE CAREFUL! By using update_all we avoid the potential of cascading touches of records
  #  related to the touched users.
  #
  after_update :touch_related_users
  before_destroy :touch_related_users

  def touch_related_users
    # logger.info 'TOUCH_RELATED_USERS'
    if self.scout?
      # logger.info "  adults: #{self.adults.map(&:name).join(', ')}"
      self.adults.update_all(updated_at: Time.now)
    elsif self.adult?
      # logger.info "  scouts: #{self.scouts.map(&:name).join(', ')}"
      self.scouts.update_all(updated_at: Time.now)
    end
  end



  # this works, except for forms with related info (e.g. new adults assigning related scouts)
  # has_many     :adult_scout_relationships,
  #              :class_name            => "UserRelationship",
  #              :foreign_key           => :scout_id,
  #              :dependent             => :destroy
  # has_many     :adults,
  #              :through               => :adult_scout_relationships,
  #              :source                => :adult

  # has_many     :scout_adult_relationships,
  #              :class_name            => "UserRelationship",
  #              :foreign_key           => :adult_id,
  #              :dependent             => :destroy
  # has_many     :scouts,
  #              :through               => :scout_adult_relationships,
  #              :source                => :scout



  # before_save :ensure_authentication_token
  before_save :update_picture_attributes
  before_create :save_original_filename
  before_create :ensure_signup_token




  def name
    full_name
  end

  def name_email
    "#{full_name} <#{email}>"
  end

  def name_sms
    "#{full_name} <#{sms_email_address}>"
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

  def f_name_l_initial
    "#{first_name} #{last_name[0]}."
  end

  def initials
    "#{first_name[0]}#{last_name[0]}".upcase
  end

  def age
    return unless birth
    now = Time.now.utc.to_date
    now.year - birth.year - ((now.month > birth.month || (now.month == birth.month && now.day >= birth.day)) ? 0 : 1)
  end


  # ROLES
  def scout?
    type == 'Scout'
  end

  def adult?
    type == 'Adult'
  end


  def role_at_least(role_q)
    return false if role.nil?
    User.roles[role_q.to_s] <= User.roles[role]
  end

  def self.roles_at_and_above(role_q)
    User.roles.select { |r| User.roles[r] >= User.roles[role_q.to_s] }
  end

  def self.roles_at_and_below(role_q)
    User.roles.select { |r| User.roles[r] <= User.roles[role_q.to_s] }
  end



  def sms_number_verified
    !sms_number_verified_at.nil?
  end

  # def all_leadership_positions
  #   [leadership_position, additional_leadership_positions].reject(&:blank?).compact.join(', ')
  # end



  def self.meta_search_json(users, unit_scope:)
    users.map { |user| user.meta_search_json(unit_scope: unit_scope) }.to_json
  end


  ## scopes
  scope :by_name_lf, -> { order('"users"."last_name" ASC, "users"."first_name" ASC') }
  # scope :with_email, -> { where('"users"."email" IS NOT NULL') }
  scope :with_email, -> { where.not(email: '') }
  scope :with_sms, -> { where.not(sms_number: '', sms_provider: '') }
  # scope :leaders, -> { where('"users"."leadership_position" IS NOT NULL OR "users"."additional_leadership_positions" IS NOT NULL') }
  # scope :leaders, -> { where(arel_table[:leadership_position].not_eq('').or(arel_table[:additional_leadership_positions].not_eq(''))) }

  scope :gets_email_blast, -> { with_email.where(blast_email: true) }
  scope :gets_sms_blast, -> { with_sms.where(blast_sms: true) }
  scope :gets_email_reminder, -> { with_email.where(event_reminder_email: true) }
  scope :gets_sms_reminder, -> { with_sms.where(event_reminder_sms: true) }
  scope :gets_email_deadline, -> { with_email.where(signup_deadline_email: true) }
  scope :gets_sms_deadline, -> { with_sms.where(signup_deadline_sms: true) }
  scope :gets_sms_message, -> { with_sms.where(sms_message: true) }

  scope :gets_weekly_newsletter, -> { with_email.where(weekly_newsletter_email: true) }
  scope :gets_monthly_newsletter, -> { with_email.where(monthly_newsletter_email: true) }

  scope :name_contains, ->(n) { where('users.first_name ILIKE ? OR users.last_name ILIKE ?', "%#{n}%", "%#{n}%") }

  pg_search_scope :pg_meta_search,
                  against: [:first_name, :last_name],
                  using: {
                    tsearch: { dictionary: 'english', any_word: true, prefix: true },
                    trigram: { threshold: 0.5 }
                  }



  def self.unit_leaders(unit)
    t = UnitPosition.arel_table
    joins(:unit_positions).where(t[:unit_id].eq(unit.id)).where(t[:leadership].not_eq('').or(t[:additional].not_eq('')))
  end

  def self.without_units
    habtm_table = Arel::Table.new(:units_users)
    join_table_with_condition = habtm_table.project(habtm_table[:user_id])
    where(User.arel_table[:id].not_in(join_table_with_condition))
  end

  def self.role_is_leader_or_above
    t = User.arel_table
    User.where(t[:role].gteq(User.roles[:leader]))
  end

  def self.unit_users_with_adults(unit:, users_ids:)
    users_ids_clean = users_ids.reject(&:blank?).map(&:to_i)

    scouts_ids = unit.scouts.where(id: users_ids_clean).pluck(:id)
    scouts_adults_ids = Adult.joins(:scouts).where(user_relationships: { scout_id: scouts_ids }).pluck(:id)
    all_ids = (users_ids_clean + scouts_adults_ids).uniq

    unit.users.where(id: all_ids)
  end



  def turn_off_all_notifications
    self.send_reminders = false
    self.blast_email = false
    self.blast_sms = false
    self.event_reminder_email = false
    self.event_reminder_sms = false
    self.signup_deadline_email = false
    self.signup_deadline_sms = false
    self.weekly_newsletter_email = false
    self.monthly_newsletter_email = false
    self.sms_message = false
  end

  def turn_off_all_notifications!
    turn_off_all_notifications
    self.save
  end


  # use by UsersController to create the counselors_attributes hash
  def self.create_counselors_attributes(user: nil, unit:, mb_ids: merit_badge_ids)
    # {"0"=>{"unit_id"=>"15", "merit_badge_id"=>"22"}, "1"=>{"unit_id"=>"15", "merit_badge_id"=>"22"}}}

    # use only unique, non-empty values (helps with validation)
    mb_ids_uniq = mb_ids.reject(&:empty?).uniq
    idx = 0
    h = Hash.new

    if user
      user.counselors.unit(unit.id).each do |c|
        # if the existing counselor's meritbadge exists in the array of mb_ids_uniq, set _destroy -> '0'
        # if the existing counselor's meritbadge does not exist in the array of mb_ids_uniq, then mark it for deletion, _destroy -> '1'
        dest = mb_ids_uniq.include?(c.merit_badge_id.to_s) ? '0' : '1'

        h["#{idx}"] = {
                        'id' => "#{c.id}",
                        'unit_id' => "#{c.unit_id}",
                        'merit_badge_id' => "#{c.merit_badge_id}",
                        '_destroy' => dest
                      }
        idx += 1
      end
    end

    # get the difference in mertibadge ids from what currently exists. the diff will be NEW records to create
    mb_diff = user.nil? ? mb_ids_uniq : (mb_ids_uniq - user.counselors.unit(unit.id).map { |c| c.merit_badge_id.to_s })
    # puts "md_diff: #{mb_diff.inspect}"
    mb_diff.each do |mbi|
      h["#{idx}"] = {
                      'unit_id' => "#{unit.id}",
                      'merit_badge_id' => mbi,
                      '_destroy' => '0'
                    }
      idx += 1
    end

    h
  end


  def event_signup_up(event)
    EventSignup.where(user_id: self.id, event_id: event.id).first
  end

  def signed_up_for_event?(event)
    EventSignup.where(user_id: self.id, event_id: event.id).exists?
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

  private

    def ensure_signup_token
      self.signup_token = valid_token
    end

    def valid_token
      loop do
        rand_token = generate_token
        break rand_token unless User.where(signup_token: rand_token).exists?
      end
    end

    def generate_token
      SecureRandom.urlsafe_base64(24) # .tr('+/=lIO0', 'pqrsxyz')
    end

    def save_original_filename
      return unless picture.present?
      self.picture_original_file_name = picture.file.original_filename
    end

    def update_picture_attributes
      return unless picture.present? && picture_changed?

      if picture.file.exists?
        self.picture_content_type = picture.file.content_type
        self.picture_file_size = picture.file.size
      else
        self.picture_content_type = nil
        self.picture_file_size = nil
      end
      self.picture_updated_at = Time.zone.now
    end
end
