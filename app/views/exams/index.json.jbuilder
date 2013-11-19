json.array!(@exams) do |exam|
  json.extract! exam, 
  json.url exam_url(exam, format: :json)
end
