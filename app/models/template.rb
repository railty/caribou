class Template < ActiveRecord::Base
	def render
		#return Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {}).render(ERB.new(self.question).result(binding))
		return Redcarpet::Markdown.new(Markdown, extensions = {}).render(ERB.new(self.question).result(binding))
		
	end
	
	def kid_name
		Faker::Name.kid_name
	end
	
	def ints(n=1, range=(2 .. 10))
		Faker::Number.ints(n, range)
	end
	
	
	def answers(n, answer, suffix, prefix='()')
		offset = (answer/10).to_i
		as = ints(n, (answer-offset .. answer+offset))
		as[0] = answer if !as.include?(answer)
		as.sort!
		
		str = ''
		as.each do |a|
			str = str + "#{prefix}#{a}#{suffix} "
		end
		answers = 'Answers||' + str
	end
	
	def append(exam)
		q = Question.new
		q.question = self.render
		q.exam = exam
		q.subject = self.subject
		q.save
		return q
	end
	
end
