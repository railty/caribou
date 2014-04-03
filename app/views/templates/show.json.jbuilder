json.extract! @template, :id, :question
md, answer = @template.render
json.set! :md, md
json.set! :answer, answer
