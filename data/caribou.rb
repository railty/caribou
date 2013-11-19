require 'rubygems'
require 'bundler/setup'
Bundler.require

require './capybara_drivers'

class Caribou
  include Capybara::DSL

  def initialize(home_url, driver=nil)
    Capybara.default_driver = :capybara_selenium_remote_chromedriver_chrome
    Capybara.default_driver = driver if driver != nil
    Capybara.app_host = home_url
  end

  def get_results(exam)
    visit('caribou/test/practice_test_login.php')
    
    dropdown = find(:xpath, "//select[@name='__form_1_contest']")
    submit = find(:xpath, "//input[@name='__form_1_submit']")
    dropdown.select exam
    submit.click

		answers = all(:xpath, "//input[@name='answer']")
		answers.each do |answer|
			#puts answer.text
		end
		answer = rand(answers.length)
		answers[answer].click if answers[answer] != nil
		click_button("Submit Answer")
      

		fill_in 'end_test', :with => 'End'
		click_button("End Test")
		page.driver.browser.switch_to.alert.accept
		File.open("#{exam}.html", 'w') { |file| file.write(page.html) }

	end

  def get_list
    visit('caribou/test/practice_test_login.php')
    
    dropdown = find(:xpath, "//select[@name='__form_1_contest']")
    submit = find(:xpath, "//input[@name='__form_1_submit']")
    exams = []
    dropdown.all("option").each do |option|
      exams << option.text
    end
		
		exams.shift
    return exams
	end

  def get_results2
    visit('caribou/test/practice_test_login.php')
    
    dropdown = find(:xpath, "//select[@name='__form_1_contest']")
    submit = find(:xpath, "//input[@name='__form_1_submit']")
    exams = []
    dropdown.all("option").each do |option|
      exams << option.text
    end
    puts exams
    dropdown.select exams[3]
    submit.click

    loop do
      results = page.execute_script("
      var results = document.evaluate('//h2', document, null, 5, null).iterateNext().innerText;
      var imgs = document.evaluate('//form//img', document, null, 5, null);
      var img = imgs.iterateNext(); 
      while (img) {
        var src = img.src;
        results = results + ',' + src;
        img = imgs.iterateNext(); 
      }
      return results;
      ")
    
      results = results.split(',')
      if results[0] =~ /Question (\d+) of (\d+) \((\d+) points\)/ then
        i  = $1.to_i
        total = $2.to_i
        score = $3.to_i
      end

      puts i
      puts current_url
      File.open("f#{i}.html", 'w') { |file| file.write(page.html) }
      page.save_screenshot("screenshot#{i}.png")

      answers = all(:xpath, "//input[@name='answer']")
      answers.each do |answer|
        #puts answer.text
      end
      sleep rand(10)
      answer = rand(answers.length)
      answers[answer].click if answers[answer] != nil
      sleep rand(10)
      click_button("Submit Answer")
      
      break if i = total
    end
    
  end
end

def dl
	#spider = Caribou.new('http://www.brocku.ca/', :capybara_selenium_remote_phantomjs)
	spider = Caribou.new('http://www.brocku.ca/')
	exams = spider.get_list
	exams.each do |exam|
		spider.get_results(exam)
		sleep rand(5)
	end
end

def dl_img(fname)
	doc = Nokogiri::HTML(File.read(fname))
	doc.xpath("//h3").each do |h3|
		txt = h3.text
		if txt =~ /Question (\d+) of (\d+) \((\d+) points\)/ then
			elem = h3
			loop do
				elem = elem.next_element
				break if elem == nil or elem.node_name == 'h3'
				if elem.node_name == 'img' then
					href = elem.attr('src')
					prefix = href.gsub(/([^\/]*)$/, '').gsub(/\/$/, '').gsub(/^\//, '')
					puts "wget --directory-prefix=#{prefix} http://www.brocku.ca#{href}"
				end
			end
		end
	end
end

Dir["*.html"].each do |html|
	dl_img(html)
end