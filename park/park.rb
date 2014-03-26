require 'rubygems'
require 'bundler/setup'
Bundler.require

require './capybara_drivers'

class Park
  include Capybara::DSL

  def initialize(home_url, driver=nil)
    Capybara.default_driver = :capybara_selenium_remote_chromedriver_chrome
    Capybara.default_driver = driver if driver != nil
    Capybara.app_host = home_url
  end

  def test
    visit('/')
		click_link('Click here for English.') if page.has_link?('Click here for English.')
		
		find(:xpath, "//select[@id='selArrMth']").select 'Aug'		
		find(:xpath, "//select[@id='selArrDay']").select '2nd'		
		find(:xpath, "//select[@id='selNumNights']").select '2'
		find(:xpath, "//select[@id='selLocation']").select 'Pinery'
		find(:xpath, "//select[@id='selMap']").select 'Riverside'
		find(:xpath, "//select[@id='selEquipment']").select 'Single Tent'
		find(:xpath, "//select[@id='selPartySize']").select '4'

		find(:xpath, "//input[@id='MainContentPlaceHolder_imageButtonList']").click

		table = find(:xpath, "//table[@class='list_new']")
		html = table["innerHTML"]

		table.all(:xpath, ".//tr").each do |tr|
			state = tr.find(:xpath, ".//td[1]/img")['title']
			site = tr.find(:xpath, ".//td[2]").text
			puts "#{site}--->#{state}"
		end

		#save_page
		#page.save_screenshot('2.png')    
	end

end

def dl
	spider = Park.new('https://reservations.ontarioparks.com/', :capybara_selenium_remote_phantomjs)
	spider.test
end

#phantomjs --webdriver=5555 --cookies-file=cookie.jar
dl