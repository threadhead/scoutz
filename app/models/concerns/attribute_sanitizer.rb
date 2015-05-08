module AttributeSanitizer
  extend ActiveSupport::Concern

  included do
    before_save :sanitize_all_attributes
  end


  class_methods do
    def sanitize_attributes(*args)
      @attributes_to_sanitize ||= []
      @attributes_to_sanitize.concat args
    end

    def attributes_to_sanitize
      @attributes_to_sanitize ||= []
    end
  end



  private

    def sanitize_all_attributes
      self.class.attributes_to_sanitize.each do |attr|
        self.send("#{attr}=", Sanitize.clean(self.read_attribute(attr), whitelist))
      end
    end

    def whitelist
      whitelist = Sanitize::Config::RELAXED.dup
      whitelist[:elements] << 'span'
      whitelist[:attributes][:all] << 'style'
      whitelist
      # Sanitize::Config.merge(
      #   Sanitize::Config::RELAXED,
      #   elements: Sanitize::Config::RELAXED[:elements] + ['span'],
      #   attributes: Sanitize::Config::RELAXED[:attributes]['span'] = ['style']
      #   )
    end

end
