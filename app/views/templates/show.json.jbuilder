json.extract! @template, :id, :question
json.set! :md, @template.render
