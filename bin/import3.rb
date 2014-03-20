class XPathFilter
  def regex_match(set, reg)
		if $debug then
			puts set
		end
    return set.map { |x| x.to_s }.join.match(/#{reg}/) != nil
  end
end

def create_question(exam_name, subject, num, score, question, answers)
	exam = Exam.where("name = ?", exam_name).first
	
	if exam == nil then
		exam = Exam.new
		exam.name = exam_name
		if exam_name =~ /Grade_(.*)$/ then
			exam.grade = $1
		end
		exam.save 
	end
	q = Question.new
	q.exam = exam
	q.num = num
	q.score = score
	q.subject = subject
	q.question = question
	q.answers = answers
	q.save
	puts "create #{num} for #{exam_name}"
end

def import_exam(filename)
	exam_name = filename.gsub('.html', '').gsub(/^data\//, '')
	puts "===============#{exam_name}"
	doc = Nokogiri::HTML(File.read(filename))
	doc.xpath("//h3[regex_match(text(), 'Question \\d+ of \\d+ \\(\\d+ points\\)')]", XPathFilter.new).each do |h3|
		question = ""
		answers = ""
		if h3.text() =~ /Question (\d+) of (\d+) \((\d)+ points\)/ then
			num = $1
			score = $3
		end
		subject = "unknown"
		elem = h3
		loop do
			elem = elem.next
			begin
				if elem.node_name=='text' then
					if elem.text =~ /Question(.*)subject(.*)/ then
						subject = $2
						if subject =~ / is (.*)./ then
							subject = $1
						else
							subject = "none"
						end
					elsif elem.text =~ /Your answer was:/ then
						create_question(exam_name, subject, num, score, question, answers)
						break 
					else
						if answers == "" then
							question = question+elem.to_html
						else
							answers = answers+elem.to_html
						end
					end
				else
					if elem.search("input").length == 0 then
						if answers == "" then
							question = question+elem.to_html
						else
							answers = answers+elem.to_html
						end
					else
						answers = answers+elem.to_html
					end
				end
			rescue
				debugger
			end
			
		end
	end
end

def import_kids_names
	male=[]
	female = []
  doc = Nokogiri::HTML(File.read('data/babynames1.html'))
  doc.xpath("//h3").each do |h3|
    if h3.text =~ /Top Names of (\d+)\-(\d+)/ then
    elsif h3.text =~ /Top Names of (\d+)/ then
      #puts "#{h3.text}"
      tbl = h3.next.next
      n = tbl.xpath(".//tr[2]/td").length
      (1 .. n).each do |i|
	names = nil
          tbl.xpath(".//tr[2]/td[#{i}]").each do |td|
		str = td.text.gsub("\n", ' ').gsub(/\s+/, ',')
		names=str.split(',')
	end
        if i > n/2 then
          female =female+names
        else
          male = male+names
	end
      end
    end
  end
  
  female.uniq!
  male.uniq!
  str = ""
  p
  male.each do |n|
	  str = str+n+"," if n!=""
  end
  str.chop!
  str = "boy_name: ["+str+"]"
  puts str
  str = ""
  female.each do |n|
	  str = str+n+"," if n!=""
  end
  str.chop!
  str = "girl_name: ["+str+"]"
  puts str
end

import_kids_names