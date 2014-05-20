require 'fileutils'
require 'mechanize'

module Scoutlander
  module Importer
    class Base
      attr_accessor :logger
      attr_reader :agent

      def initialize(options={})
        @email = options[:email]
        @password = options[:password]
        @unit = options[:unit]
        @agent = nil

        # @logger_io = StringIO.new
        # @logger = Logger.new(@logger_io)
        FileUtils.mkdir_p File.join(Rails.root, 'log', 'importers')
        file = File.new(File.join(Rails.root, 'log', 'importers', logger_filename), 'a')
        @logger = Logger.new(file)
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
        "#{class_name}_unit_#{@unit.id}_#{time_number}.log"
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

      def log
        @logger_io.string
      end


    end
  end
end
