class String
  def js_replace(pattern, &block)
    gsub(pattern) do |_|
      md = Regexp.last_match
      args = [md.to_s, md.captures, md.begin(0), self].flatten
      block.call(*args)
    end
  end
end

class Markdown < Redcarpet::Render::HTML
	def preprocess(text)
		text = _CreateVerticalRadioButtonInput(text)
		#text = _CreateVerticalCheckboxInput(text)
		return text
  end
 
	def _CreateVerticalRadioButtonInput(text)
	#
	# Creates a group of radio buttons in vertical list.
	# Converts text of the form:
	#
	# sex || (x) male () female
	#
	# into:
	#
	# <label>Sex:</label>
	# <input type="radio" name="sex" id="male" value="male" checked="checked"/>
	# <label for="male">Male</label>
	# <input type="radio" name="sex" id="female" value="female"/>
	# <label for="female">Female</label>
	#
	# Right now it only works on single-line expressions.
	# 
	# TODO: Make this work across multiple lines.
	#
		regex = /(\w[\w \t\-]*)\|\|[ \t]*(\(x?\)[ \t]*[\w \t\-\/]+[\(\)\w \t\-\/]*)/
		
		return text.js_replace(regex) do |whole, name, options|
			cleanedName = name.strip.gsub(/\t/, ' ')
			inputName = cleanedName.gsub(/[ \t]/, '_').downcase
			cleanedOptions = options.strip.gsub(/\t/, ' ')
			labelName = cleanedName + ":"
			output = '<label>' + labelName + '</label><ol>'
			optRegex = /\((x?)\)[ \t]*([a-zA-Z0-9 \t_\-\/]+)/
			match = cleanedOptions.match(optRegex)
			while (match) do
				id = match[2].strip.gsub(/\t/, ' ').gsub(/[ \t]/, '_').downcase
				checkboxLabel = match[2].strip.gsub(/\t/, ' ')
				checked = match[1] == 'x'
				output = output + '<li><input type="radio" name="' + inputName + '" id="' + id + '" value="' + id + '" ' + (checked ? 'checked="checked"' : '') + '/>'
				output = output + '<label for="' + id + '">' + checkboxLabel + '</label></li>'
				cleanedOptions = match.post_match
				match = cleanedOptions.match(optRegex)
			end
		
			output += '</ol>'
			return output
		end
	end
end