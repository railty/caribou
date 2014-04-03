t = Template.first
e = Exam.where("name='exam1'").first
puts e.questions.length
t.append(e)