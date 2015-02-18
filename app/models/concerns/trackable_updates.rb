module TrackableUpdates
  extend ActiveSupport::Concern

  # this module will allow the tracking of changes to a model and the user that made the changes

  # IMPORTANT: must of the update_history:text attribute added to table
  # rails generate migration AddTrackableUpdatesToWidgets update_history:text

  included do
    if self.column_names.include?('update_history')
      include ActiveModel::Dirty
      before_save :history_update, if: :changed?
      if self.ancestors.include?(Deactivatable)
        after_deactivation :history_deactivated
      end
    end
  end

  class_methods do
    def trackable_user_resource(resource)
      @trackable_user_resource = resource
    end

    def trackable_user
      @trackable_user_resource ||= ( User if defined?(User) )
    end
  end

  private
    def history_update
      self.new_record? ? history_created : history_changed
    end

    def history_created
      update_history_append "#{history_timestamp} #{history_user} created"
    end

    def history_changed
      chgs = history_valid_changes.map do |change|
        history_from_to(change[0], change[1])
      end
      update_history_append "#{history_timestamp} #{history_user} #{chgs.join(', ')}" unless chgs.blank?
    end




    def history_from_to(k, v)
      if k == 'body'
        "edited the body"
      else
        "changed #{k} from #{history_value k, v[0]} to #{history_value k, v[1]}"
      end
    end

    def history_deactivated
      update_history_append "#{history_timestamp} #{history_user} deactivated"
      self.save(validate: false)
    end

    def history_invalid_attributes
      %w(update_history deactivated_at active_changed_by_id)
    end

    def history_masked_attributes
      %w(password)
    end

    def history_valid_changes
      dup = self.changes.clone
      history_invalid_attributes.each { |key| dup.delete(key) }
      dup
    end




    def history_timestamp
      "#{Time.zone.now.to_s} -"
    end

    def history_user
      user = self.class.trackable_user.current
      user ? "#{user.name}(#{user.id})" : '<unknown_user>'
    end

    def history_value(k, v)
      return "<FILTERED>" if history_masked_attributes.include?(k)
      v.blank? ? '<empty>' : v
    end

    def update_history_append(msg)
      self.update_history = (self.update_history.to_s + "\n" + msg).lstrip
    end
end
