class HealthForm < ActiveRecord::Base
  belongs_to :user
  belongs_to :unit

  validates :user_id, presence: true
  validates :unit_id, presence: true

  def part_a_expires
    expires_at part_a_date
  end

  def part_b_expires
    expires_at part_b_date
  end

  def part_c_expires
    expires_at part_c_date
  end

  def florida_sea_base_expires
    expires_at florida_sea_base_date
  end

  def northern_tier_expires
    expires_at northern_tier_date
  end

  def summit_tier_expires
    expires_at summit_tier_date
  end

  def philmont_expires
    expires_at philmont_date
  end

  private
    def expires_at(date)
      return nil if date.nil?
      date + 1.year - 1.day
    end
end
