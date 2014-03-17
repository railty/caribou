def f
end


$hrefs = []
def dl_img(fname)
	doc = Nokogiri::HTML(File.read(fname))
	doc.xpath("//h3").each do |h3|
		txt = h3.text
		if txt =~ /Question (\d+) of (\d+) \((\d+) points\)/ then
			num = $1.to_i
			score = $3.to_i
			body = h3.to_html

			elem = h3
			loop do
				elem = elem.next
				break if elem == nil or elem.node_name == 'h3'
				body = body+elem.to_html
				
				elem.xpath("//img").each do |img|
					href = img.attr('src')
					$hrefs << href
				end
				break if elem.node_name == 'ol'
			end

			exam_name = fname.gsub('.html', '').gsub(/^data\//, '')
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
			q.body = body
			q.score = score
			q.save

		end
	end
end

def dl_imgs
	Question.destroy_all
	Exam.destroy_all
	Dir["data/*.html"].each do |html|
		dl_img(html)
	end

	$hrefs.uniq!
	$hrefs.each do |href|
		href.gsub!('http://www.brocku.ca', '')
		if !File.exist?("public#{href}") then
			puts "public#{href}"
			prefix = href.gsub(/([^\/]*)$/, '').gsub(/\/$/, '').gsub(/^\//, '')
			puts "wget --directory-prefix=#{prefix} http://www.brocku.ca#{href}"
		end
	end
end

$jss = []
def dl_js(fname)
	doc = Nokogiri::HTML(File.read(fname))
	doc.xpath("//script").each do |script|
		$jss << script['src'] if script['src'] != nil
	end
end

def dl_category(fname)
	exam_name = fname.gsub('.html', '').gsub(/^data\//, '')
	exam = Exam.where("name = ?", exam_name).first
	
	doc = Nokogiri::HTML(File.read(fname))
	doc.xpath("//h3").each do |h3|
		txt = h3.text
		if txt =~ /Question (\d+) of (\d+) \((\d+) points\)/ then
			num = $1.to_i	#question num of total
			score = $3.to_i #x points
			body = h3.to_html

			elem = h3
			loop do
				elem = elem.next
				break if elem == nil or elem.node_name == 'h3'
				body = body+elem.to_html
				break if elem.node_name == 'ol'
			end


			if elem!=nil and elem.next !=nil then
				puts "=========#{num}"
				puts elem.next.to_html
				puts "-----------"
				puts elem.to_html
			end

		end
	end
end


def dl_categories
	Dir["data/*.html"].each do |html|
		dl_category(html)
	end
end

def dl_jss
	Dir["data/*.html"].each do |html|
		dl_js(html)
	end
	$jss.uniq!
	$jss.each do |js|
		prefix = js.gsub(/([^\/]*)$/, '').gsub(/\/$/, '').gsub(/^\//, '')
		puts "wget --directory-prefix=#{prefix} http://www.brocku.ca#{js}"
	end
end

dl_categories