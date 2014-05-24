module Scoutlander
  module Importer
    class TdReader
      attr_accessor :page, :id

      def initialize(options={})
        @page = options[:page]
        @id = options[:id]
      end

      def get_text_with(identity)
        # puts "identity: #{identity}"
        return nil unless @page.is_a?(Mechanize::Page)
        val = @page.at("#{@id}#{identity}").try(:text)
        val.blank? ? nil : val
      end

    end
  end
end
