require 'rubygems'
require 'mechanize'

class Scoutlander

	def initialize(email, password)
		@email = email
		@password = password
	end

	def import_sub_units
		agent = ::Mechanize.new
		page = agent.get('http://scoutlander.com/publicsite/home.aspx')
		login_form = page.form('aspnetForm')
		login_form.field_with(:name => 'ctl00$mainContent$LoginBox$txtUsername').value = @email
		login_form.field_with(:name => 'ctl00$mainContent$LoginBox$txtPassword').value = @password
		dash_page = agent.submit(login_form)

		dash_page
	end
end