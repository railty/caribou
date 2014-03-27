require 'mail'
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

  def dl_info
    str = ""
    visit('/')
		click_link('Click here for English.') if page.has_link?('Click here for English.')
		
		find(:xpath, "//select[@id='selArrMth']").select 'Aug'		
		find(:xpath, "//select[@id='selArrDay']").select '2nd'		
		find(:xpath, "//select[@id='selNumNights']").select '2'
		find(:xpath, "//select[@id='selLocation']").select 'Pinery'

		while has_no_selector?(:xpath, "//select[@id='selMap']/option[text()='Riverside']") do
			puts "waiting"
			sleep 100
		end

		find(:xpath, "//select[@id='selMap']").select 'Riverside'
		find(:xpath, "//select[@id='selEquipment']").select 'Single Tent'
		find(:xpath, "//select[@id='selPartySize']").select '4'

		find(:xpath, "//input[@id='MainContentPlaceHolder_imageButtonList']").click

		table = find(:xpath, "//table[@class='list_new']")
		html = table["innerHTML"]

		table.all(:xpath, ".//tr").each do |tr|
			state = tr.find(:xpath, ".//td[1]/img")['title']
			site = tr.find(:xpath, ".//td[2]").text
			str = str + "#{site}--->#{state}\n"
		end

#		save_page
#		page.save_screenshot('2.png')    
    return str	
	end

end

def dl
options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'orientalfoods.ca',
            :user_name            => 'automan@orientalfoods.ca',
            :password             => '3pokemon',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }

	spider = Park.new('https://reservations.ontarioparks.com/', :capybara_selenium_remote_phantomjs)
	str = spider.dl_info
	f = File.open("data.txt", "a+")
	f.puts Time.now
	f.puts str
	f.close

Mail.deliver do
	delivery_method :smtp, options
       to 'zxning@gmail.com'
     from 'shawn.ning@list4d.com'
  subject 'testing sendmail'
     body str
end

end

system 'phantomjs --webdriver=5555 --webdriver-logfile=log.txt >log.txt &'
pid = $?
sleep 1
puts "========================="
dl
`kill $(ps -A|grep phantomjs|awk '{print $1}')`






