require 'fileutils'
require 'mechanize'

module MbDotOrg
  module Importer
    class Base
      attr_accessor :logger, :collection
      attr_reader :agent

      def initialize(options={})
        @collection = []
        @agent = nil

        # @logger_io = StringIO.new
        # @logger = Logger.new(@logger_io)
        @logger = if Rails.env.test?
                    Logger.new('/dev/null')
                  else
                    FileUtils.mkdir_p File.join(Rails.root, 'log', 'importers')
                    file = File.new(File.join(Rails.root, 'log', 'importers', logger_filename), 'a')
                    Logger.new(file)
                  end
        @logger.formatter = proc do |_severity, datetime, _progname, msg|
          "[#{datetime.utc.strftime '%Y-%m-%d %H:%M:%SZ'}] #{msg}\n"
        end
      end

      def class_name
        self.class.name.split('::').last.downcase
      end

      def time_number
        Time.now.utc.to_s(:filename)
      end

      def logger_filename
        "merit_badge_dot_org_#{time_number}.log"
      end



      def clean_string(str)
        # uses the POSIX space characters, which includes space, non-breaking space, and more
        return if str.nil?
        str.gsub(/\A[[:space:]]+|[[:space:]]+\z/, '')
      end

      def log
        @logger_io.string if @logger_io
      end


      # queries a collection of daum elements returning matches to the key_vals pairs
      def find_collection_elements_with(*key_vals)
        self.collection.select do |elem|
          key_vals.all? do |kv|
            k, v = kv.first
            return unless elem.respond_to?(k.to_sym)
            elem.send(k.to_sym) == v
          end
        end
      end
    end
  end
end
