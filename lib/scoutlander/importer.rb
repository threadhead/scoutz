require 'rubygems'
require 'mechanize'
require 'unit'
require 'person'

module Scoutlander
	class Importer

		def initialize(email, password)
			@email = email
			@password = password
			@agent = nil
			@units = nil
			@sub_units = nil
			@parents = []
			@children = []
			@units = []
		end

		def sub_units(unit)
			# sub_units (dens, patrols, etc.) are on the setup wizard page, item #3
			# listed in a table, with the second column the list of names
			if @sub_units.nil?
				dash_page = login
				unit_page = @agent.dash_page.link_with(:text => unit).click
				site_setup_wizard_page = unit_page.link_with(:text => %r/Site Setup Wizard/).click
				add_dens_page = site_setup_wizard_page.link_with(:text => %r/Add Dens or Patrols/).click
				@sub_units = add_dens_page.search("table#ctl00_mainContent_adminsubunitmgr_tblData tr td[2]").children.map(&:text)[1..-2]
			end
		end

		def units
			if @units.empty?
				dash_page = login
				sites = dash_page.search("a.mysites")
				sites.each do |site|
					uid = find_uid(site['href'])
					name = site.child.text.strip
					@units << Scoutldaner::Unit.new(uid: uid, name: name)
				end
				# @units = dash_page.search("a.mysites").children.map(&:text)
			end
		end

		def active_parents(unit)
			parents = @agent.get("http://scoutlander.com/securesite/parentmain.aspx?UID=#{unit.uid}")
			# get the table rows, excluding the first two header rows
			rows = parents.search('table#ctl00_mainContent_ParentSearch_tblPersonSearch tr')[2..-1]
			rows.each do |row|
				parent = Person.new

				row.children.children.each do |td|
					if td.name = 'a'
						if td['href'] =~ /parentmain/
							parent.last_name, parent.first_name = td.text.split(', ')
							parent.uid = find_profile(td['href'])

						elsif td['href'] =~ /scoutmain/
							scout = Person.new
							scout.uid = find_uid(td['href'])
							parent.add_relation(scout)
						end
					end
				end

				parent = Person.new
				parent.last_name, parent.first_name = row.children.children[1].text.split(', ')
				parent.uid = find_profile_id(row.children.children[1]['href'])
				scout = Person.new
				scout.first_name, scout.last_name = row.children.children[4].text.split(' ')
				@parents << parent
			end
		end



		def login
			@agent = ::Mechanize.new
			page = @agent.get('http://scoutlander.com/publicsite/home.aspx')
			login_form = page.form('aspnetForm')
			login_form.field_with(:name => 'ctl00$mainContent$LoginBox$txtUsername').value = @email
			login_form.field_with(:name => 'ctl00$mainContent$LoginBox$txtPassword').value = @password
			agent.submit(login_form, login_form.buttons.first)
		end

		def logout
			@agent.get('http://scoutlander.com/common/LogOff.aspx')
		end


		def find_uid(url)
			parse_query_params(url)[:uid]
		end

		def find_profile_id(url)
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
	end

end
