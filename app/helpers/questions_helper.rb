module QuestionsHelper
	def to_html(question)
		if question.material=='html' then
			return question.question.html_safe
		elsif question.material=='md' then
			
		elsif question.material=='game' then
		else 
		end
	end
end
