require 'fileutils'
require 'mechanize'

module Scoutlander
  module Reader
    class Base
      attr_accessor :logger, :collection
      attr_reader :agent

      def initialize(options={})
        @collection = []
        @email = options[:email]
        @password = options[:password]
        @unit = options[:unit]
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
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "[#{datetime.utc.strftime "%Y-%m-%d %H:%M:%SZ"}] #{msg}\n"
        end
      end

      def class_name
        self.class.name.split("::").last.downcase
      end

      def time_number
        Time.now.utc.to_s(:filename)
      end

      def logger_filename
        "#{class_name}_unit_#{@unit.try(:id)}_#{time_number}.log"
      end

      def login
        @agent ||= ::Mechanize.new
        unless logged_in?
          page = @agent.get('http://www.scoutlander.com/publicsite/home.aspx')
          @logger.info "Login to Scoutlander.com -> GET 'http://www.scoutlander.com/publicsite/home.aspx', username: #{@email}"
          login_form = page.form('aspnetForm')
          login_form.field_with(name: 'ctl00$mainContent$LoginBox$txtUsername').value = @email
          login_form.field_with(name: 'ctl00$mainContent$LoginBox$txtPassword').value = @password
          login_form.checkboxes.first.checked = true
          @agent.submit(login_form, login_form.buttons.first)
          @logger.info "PAGE TITLE : #{@agent.page.title.strip.chomp}"
        end
        @agent.current_page
      end

      def logout
        @agent.get('/common/LogOff.aspx')
        @logger.info "Logout of Scoutlander.com - GET /common/LogOff.aspx"
        @agent.current_page
      end

      def logged_in?
        @logged_in = !!(@agent && @agent.current_page && @agent.current_page.link_with(text: /Logout/))
      end


      def uid_from_url(url)
        parse_query_params(url)[:uid]
      end

      def profile_from_url(url)
        parse_query_params(url)[:profile]
      end

      def profile_id(url)
        parse_query_params(url)[:profile]
      end

      def parse_query_params(url)
        h = {}
        url.split('?').last.split('&').each do |qe|
          k,v = qe.split('=')
          h.merge!({k.downcase.to_sym => v})
        end
        h
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
            k,v = kv.first
            return unless elem.respond_to?(k.to_sym)
            elem.send(k.to_sym) == v
          end
        end
      end


    end
  end
end
