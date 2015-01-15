module SubUnitIds
  extend ActiveSupport::Concern

  included do
    # serialize :sub_unit_ids, Array

    validate :has_selected_sub_units, if: :send_to_sub_units?
    def has_selected_sub_units
      errors.add(:base, "You must select at least 1 #{self.unit.try(:sub_unit_name)}") if sub_unit_ids.empty?
    end
  end

  # module ClassMethods
  # end


  # the default: Array.new for serialized columns does not work
  # this is the workaround
  # def sub_unit_ids
  #   value = super
  #   if value.is_a?(Array)
  #     value
  #   else
  #     self.sub_unit_ids = Array.new
  #   end
  # end

  def sub_units
    SubUnit.where(id: sub_unit_ids).order(:name)
  end

end
