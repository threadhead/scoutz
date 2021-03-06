class EmailMessage < ActiveRecord::Base
  include SendToOptions
  include SubUnitIds
  include AttributeSanitizer
  include Deactivatable

  serialize :sub_unit_ids, Array
  serialize :sent_to_hash, Hash

  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  belongs_to :unit
  belongs_to :email_group
  has_many :email_attachments, dependent: :destroy
  has_and_belongs_to_many :events
  has_and_belongs_to_many :users
  accepts_nested_attributes_for :email_attachments, allow_destroy: true, reject_if: proc { |a| a['attachment'].blank? }


  validates :message, presence: true, if: :has_no_events?
  validates :subject, presence: true
  validates_associated :email_attachments

  sanitize_attributes :message

  validate :has_selected_users, if: :send_to_users?
  def has_selected_users
    errors.add(:base, 'You must select at least 1 adult or scout recipient') if user_ids.empty?
  end

  validate :has_selected_email_group, if: :send_to_group?
  def has_selected_email_group
    errors.add(:base, 'You must select an email group') if email_group.blank?
  end

  before_create :ensure_id_token



  def has_attachments?
    self.email_attachments.count > 0
  end

  def events_have_signup?
    self.events.where(signup_required: true).count > 0
  end

  def has_events?
    self.events.count > 0
  end


  def sent_to_count
    sent_to_hash.size
  end


  def subject_with_unit
    "#{subject} #{self.unit.email_name}"
  end

  def recipients
    @recipients ||= case send_to_option
                    when 1
                      self.unit.users.gets_email_blast
                    when 2
                      self.unit.users.unit_leaders(self.unit).gets_email_blast
                    when 3
                      # su_users = []
                      # sub_units.each { |su| su_users << su.users_receiving_email_blast }
                      # su_users.flatten
                      sub_units.inject([]) { |users, su| users + su.users_receiving_email_blast }.uniq
                    when 4
                      # self.users.gets_email_blast
                      User.unit_users_with_adults(unit: unit, users_ids: users.pluck(:id)).gets_email_blast
                    when 5
                      self.unit.scoutmasters.gets_email_blast
                    when 8
                      self.email_group.users_with_adults.gets_email_blast

                    else
                      []
                    end
  end

  def recipients_emails
    recipients.map(&:email).uniq
  end

  def recipients_ids
    recipients.map(&:id)
  end

  def sent_to
    User.where(id: sent_to_hash.keys).by_name_lf
  end

  def add_sent_confirmation!(user:, status: 'ok')
    self.sent_to_hash[user.id] = {
      sent_at: Time.zone.now.iso8601,
      status: status
    }
    save(validate: false)
  end



  # scopes
  scope :by_updated_at, -> { order(updated_at: :desc) }

  protected

    def has_no_events?
      if self.persisted?
        has_events?
      else
        self.event_ids.empty?
      end
    end

  private

    def ensure_id_token
      self.id_token = valid_token
    end

    def valid_token
      loop do
        rand_token = generate_token
        break rand_token unless EmailMessage.where(id_token: rand_token).first
      end
    end

    def generate_token
      SecureRandom.urlsafe_base64(12) # .tr('+/=lIO0', 'pqrsxyz')
    end

end
