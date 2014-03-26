
Capybara.run_server = false
Capybara.default_wait_time = 2

UA_LX_FIREFOX = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0"
UA_LX_CHROMIUM = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/28.0.1500.71 Chrome/28.0.1500.71 Safari/537.36"
UA_WIN_CHROME = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36"
UA_WIN_FIREFOX = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:21.0) Gecko/20100101 Firefox/21.0"
UA_WIN_IE = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)"

ua = UA_LX_CHROMIUM
#w = 1024
#h = 768
w = 800
h = 600

#capybara drive poltergeist drive phantomjs
Capybara.register_driver :capybara_poltergeist_phantomjs do |app|
  require 'capybara/poltergeist'
  driver = Capybara::Poltergeist::Driver.new(app)
  driver.headers = {"User-Agent" => ua}
  driver.resize(w, h)
  driver
end

#capybara drive selenium drive firefox
Capybara.register_driver :capybara_selenium_firefox_new_profile do |app|
  require 'selenium/webdriver'
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['general.useragent.override'] = ua
  driver = Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
  driver.browser.manage.window.resize_to(w, h)
  driver
end

#capybara drive selenium drive chrome
Capybara.register_driver :capybara_selenium_chrome_existing_profile do |app|
  require 'selenium/webdriver'
  #use a existing profile, if it is not exist, will create a new one
  driver = Capybara::Selenium::Driver.new(app, :browser => :chrome, :switches => %W[--user-agent=#{UA_LX_FIREFOX}, --user-data-dir=/tmp/profile])
  driver.browser.manage.window.resize_to(w, h)
  driver
end

#capybara drive selenium drive phantomjs
Capybara.register_driver :capybara_selenium_phantomjs do |app|
  require 'selenium/webdriver'
  cap = Selenium::WebDriver::Remote::Capabilities.phantomjs("phantomjs.page.settings.userAgent" => ua)
  driver = Capybara::Selenium::Driver.new(app, :browser => :phantomjs, :desired_capabilities => cap)
  driver.browser.manage.window.resize_to(w, h)
  driver
end


#capybara drive selenium remote drive firefox use new profile with updated ua
#only support firefox with firefox_profile
Capybara.register_driver :capybara_selenium_remote_selenium_firefox do |app|
  require 'selenium/webdriver'
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['general.useragent.override'] = ua
  cap = Selenium::WebDriver::Remote::Capabilities.new({:firefox_profile => profile, :browser_name => "firefox"})
  driver = Capybara::Selenium::Driver.new(app, :browser => :remote, :url => "http://localhost:4444/wd/hub", :desired_capabilities => cap)
  driver.browser.manage.window.resize_to(w, h)
  driver
end

#capybara drive selenium remote drive chromium
#cannot set the switches, therefore cannot set profile or user agent
#use chrome webdriver instead
Capybara.register_driver :capybara_selenium_remote_selenium_chrome do |app|
  require 'selenium/webdriver'
  cap = Selenium::WebDriver::Remote::Capabilities.new({:browser_name => "chrome"})
  driver = Capybara::Selenium::Driver.new(app, :browser => :remote, :url => "http://localhost:4444/wd/hub", :desired_capabilities => cap)
  driver.browser.manage.window.resize_to(w, h)
  driver
end

#capybara drive selenium remote drive phantomjs
#cannot set the switches, therefore cannot set profile or user agent
#use phantomjs webdriver instead
Capybara.register_driver :capybara_selenium_remote_selenium_phantomjs do |app|
  require 'selenium/webdriver'
  cap = Selenium::WebDriver::Remote::Capabilities.new({:browser_name => "phantomjs", :javascript_enabled=>true})
  driver = Capybara::Selenium::Driver.new(app, :browser => :remote, :url => "http://localhost:4444/wd/hub", :desired_capabilities => cap)
  driver.browser.manage.window.resize_to(w, h)
  driver
end

#capybara drive selenium remote drive chromium
Capybara.register_driver :capybara_selenium_remote_chromedriver_chrome do |app|
  require 'selenium/webdriver'
  cap = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => %W(--user-agent=#{UA_LX_FIREFOX}, --user-data-dir=/tmp/profile)})
  driver = Capybara::Selenium::Driver.new(app, :browser => :remote, :url => "http://localhost:9515", :desired_capabilities => cap)
  driver.browser.manage.window.resize_to(w, h)
  driver
end

#capybara drive selenium remote drive chromium
Capybara.register_driver :capybara_selenium_remote_phantomjs do |app|
  require 'selenium/webdriver'
  cap = Selenium::WebDriver::Remote::Capabilities.phantomjs('phantomjs.page.settings.userAgent'=> ua)
  driver = Capybara::Selenium::Driver.new(app, :browser => :remote, :url => "http://localhost:5555", :desired_capabilities => cap)
  driver.browser.manage.window.resize_to(w, h)
  driver
end

#Capybara.drivers.each do |x|
#  puts x[0]
#end
