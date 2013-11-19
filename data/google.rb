require 'rubygems'
require 'bundler/setup'
Bundler.require

require './capybara_drivers'

class Google
  include Capybara::DSL

  def initialize(home_url, driver=nil)
    #Capybara.default_driver = :capybara_selenium_remote_chromedriver_chrome
    Capybara.default_driver = :capybara_selenium_remote_selenium_firefox
    Capybara.default_driver = driver if driver != nil
    Capybara.app_host = home_url
  end
  
  def get_results
    visit('/')
    x = page.find(:xpath, "//input[@name='p']")
    x.native.send_keys(:f12)
    sleep 2
    x = page.execute_script("
        var x = document.title;
        debugger;
        document.title = 'This is the new page title.';
        return x;
    ")
    puts x
    gets
  end
  
  def get_results2
    visit('/')
    
    fill_in 'p', :with=>"capybara"
    click_button("Search")

debugger
    #Keyboard keyboard = ((HasInputDevices) driver).getKeyboard();
    #keyboard.sendKeys(Keys.F12);


    all(:xpath, "//div[@class='mmdd imgdd']//img").each do |img|
#      puts img['src']
 #     img['src'].gsub!('/', '_').gsub!(':', '_')
      
      x = page.execute_script("
        var x = document.title;
        debugger;
        document.title = 'This is the new page title.';
        return x;
    ")
    
      gets
      
    end

    File.open("test.html", 'w') { |file| file.write(page.html) }
    sleep 10000
  end
end


spider = Google.new('http://ca.yahoo.com/?p=us')
spider.get_results
