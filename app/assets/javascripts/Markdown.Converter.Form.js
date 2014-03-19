// Capitalizes a string
var capitalize = function (str) {
	return str.charAt(0).toUpperCase() + str.slice(1);
}

var _Templater = {
	format: function(template, values) {
		//
		// Utility function that replaces placeholders with parameterized values
		//
		// Example:
		// Inputs:
		// template = 'Here is some text: %text%'
		// values = {'text', 'Hello I am text!'}
		//
		// Output:
		// 'Here is some text: Hello I am text!'
		//
		// @param template The template to do replacements on.  Fields to be replaced should be surrounded
		//                 by percentage signs (e.g. %field%)
		// @param values A Javascript object literal containing the names of the fields to be replaced
		//               along with the replacement values (e.g. {'field': 'Replacement text'}
		for (value in values) {
			template = template.replace(new RegExp('%' + value + '%', 'g'), values[value], 'g');
		}
		return template;
	}
}

var _CreateFormTextInput = function (text) {
	//
	// Creates a form text input element.
	// Converts text of the form:
	//
	// "first name = ___"
	//
	// into a form input like:
	//
	// <label for="first_name">First Name:</label>
	// <input type="text" id="first_name" name="first_name" size="20"/>
	//
	// Or specifying input field size:
	//
	// "first name = ___[50]"
	//
	// into:
	// 
	// <label for="first_name">First Name:</label>
	// <input type="text" id="first_name" name="first_name" size="50"/>
	//
	// Or specifying a required field:
	//
	// "first name* = ___"
	//
	// into:
	//
	// <label for="first-name" class="required-label">First Name*:</label>
	// <input type="text" id="first-name" name="first-name" size="20" class="required-input"/>
	//
	// Specifics:
	// * Each form input created in this way should be on its own line.
	// * Requires exactly 3 underscores on the right-hand side of the equals sign.
	// * Currently does not check whether a <form> tag has been opened.
	// 
	return text.replace(/(\w[\w \t\-]*(\*)?)[ \t]*=[ \t]*___(\[\d+\])?/g, function(wholeMatch, lhs, required, size) {
		var cleaned = lhs.replace(/\*/g, '').trim().replace(/\t/g, ' ').toLowerCase();
		var inputName = cleaned.replace(/[ \t]/g, '-'); // convert spaces to hyphens
		var labelName = cleaned.split(' ').map(capitalize).join(' ') + (required ? '*:' : ':');
		var template = '<label for="%id%" class="%labelClass%">%label%</label>' +
						 '<input type="text" id="%id%" name="%id%" size="%size%" class="%inputClass%"/>';
		size = size ? size.match(/\d+/g)[0] : 20;
		var labelClass = required ? 'required-label' : '';
		var inputClass = required ? 'required-input' : '';
		return _Templater.format(template, {id: inputName, label: labelName, size: size, labelClass: labelClass, inputClass: inputClass});
	});
};

var _CreateRadioButtonInput = function (text) {
	//
	// Creates a group of radio buttons.
	// Converts text of the form:
	//
	// sex = (x) male () female
	//
	// into:
	//
	// <label>Sex:</label>
	// <input type="radio" name="sex" id="male" value="male" checked="checked"/>
	// <label for="male">Male</label>
	// <input type="radio" name="sex" id="female" value="female"/>
	// <label for="female">Female</label>
	//
	// Right now it only works on single-line expressions.
	// 
	// TODO: Make this work across multiple lines.
	//
	var regex = /(\w[\w \t\-]*)=[ \t]*(\(x?\)[ \t]*[\w \t\-]+[\(\)\w \t\-]*)/g;
	return text.replace(regex, function(whole, name, options) {
		var cleanedName = name.trim().replace(/\t/g, ' ');
		var inputName = cleanedName.replace(/[ \t]/g, '_').toLowerCase();
		var cleanedOptions = options.trim().replace(/\t/g, ' ');
		var labelName = cleanedName + ":";
		var output = '<label>' + labelName + '</label>';
		var optRegex = /\((x?)\)[ \t]*([a-zA-Z0-9 \t_\-]+)/g;
		var match = optRegex.exec(cleanedOptions);
		while (match) {
			var id = match[2].trim().replace(/\t/g, ' ').replace(/[ \t]/g, '_').toLowerCase();
			var checkboxLabel = match[2].trim().replace(/\t/g, ' ');
			var checked = match[1] == 'x';
			output += '<input type="radio" name="' + inputName + '" id="' + id + 
						'" value="' + id + '" ' + (checked ? 'checked="checked"' : '') + '/>';
			output += '<label for="' + id + '">' + checkboxLabel + '</label>';
			match = optRegex.exec(cleanedOptions);
		}
		return output;
	});
}

var _CreateCheckboxInput = function (text) {
	//
	// Creates a group of checkboxes.
	// Converts text of the form:
	//
	// phones = [] Android [x] iPhone [x] Blackberry
	//
	// into:
	//
	// <label>Phones:</label> 
	// <input type="checkbox" name="phones" id="Android" value="Android"/>
	// <label for="Android">Android</label>
	// <input type="checkbox" name="phones" id="iPhone" value="iPhone" checked="checked"/>
	// <label for="iPhone">iPhone</label>
	// <input type="checkbox" name="phones" id="Blackberry" value="Blackberry" checked="checked"/>
	// <label for="Blackberry">Blackberry</label>
	//
	// Right now it only works on single-line expressions.
	// 
	// TODO: Make this work across multiple lines.
	//
	var regex = /(\w[\w \t\-]*)=[ \t]*(\[x?\][ \t]*[\w \t\-]+[\[\]\w \t\-]*)/g;
	return text.replace(regex, function(whole, name, options) {
		var cleanedName = name.trim().replace(/\t/g, ' ');
		var inputName = cleanedName.replace(/[ \t]/g, '_').toLowerCase();
		var cleanedOptions = options.trim().replace(/\t/g, ' ');
		var labelName = cleanedName + ":";
		var output = '<label>' + labelName + '</label>';
		var optRegex = /\[(x?)\][ \t]*([\w \t\-]+)/g;
		var match = optRegex.exec(cleanedOptions);
		while (match) {
			var id = match[2].trim().replace(/\t/g, ' ').replace(/[ \t]/g, '_').toLowerCase();
			var checkboxLabel = match[2].trim().replace(/\t/g, ' ');
			var checked = match[1] == 'x';
			output += '<input type="checkbox" name="' + inputName + '" id="' + id + 
						'" value="' + id + '" ' + (checked ? 'checked="checked"' : '') + '/>';
			output += '<label for="' + id + '">' + checkboxLabel + '</label>';
			match = optRegex.exec(cleanedOptions);
		}
		return output;
	});
};

var _CreateDropdownInput = function (text) {
	//
	// Creates an HTML dropdown menu.
	//
	// Text can be one of two forms:
	// 1) Label Text = {Option1, Option2, (Option3)}
	//    becomes:
	//    <label for="label_text">Label Text:</label>
	//    <select id="label_text" name="label_text">
	//    <option value="Option1">Option1</option>
	//    <option value="Option2">Option2</option>
			//	  <option value="Option3" selected="selected">Option3</option>
	//    </select>
	// 2) Label Text = {Value1 -> Option1, (Value2 -> Option2)}
	//    becomes:
	//    <label for="label_text">Label Text:</label>
	//    <select id="label_text" name="label_text">
	//    <option value="Value1">Option1</option>
	//    <option value="Value2" selected="selected">Option2</option>
	//    </select>
	//
	// These can be mixed and matched, e.g. "Label Text = {Option1, Value2 -> Option2, Option3, (Value4 -> Option4)}"
	//
	// Any spaces on the left-hand side of the equal-sign will be converted into underscores
	// to use as the id and name fields for the label and select tags.
	//
	var regex = /(\w[\w \t_\-]*)=[ \t]*\{([a-zA-Z0-9 \t\->_,\(\)]+)\}/g;
	return text.replace(regex, function(whole, name, options) {
		var cleanedName = name.trim().replace(/\t/g, ' ');
		var id = cleanedName.replace(/[ \t]/g, '_').toLowerCase();
		var output = '<label for="' + id + '">' + cleanedName + ':</label>\n' +
					 '<select id="' + id + '" name="' + id + '">';
		options.split(',').forEach(function(opt) {
			var selectedItemRegex = /\((.*)\)/g;
			// Test to see if option is surrounded by parens, indicating it's the default option
			var match = selectedItemRegex.exec(opt);
			var contents = match ? match[1].trim() : opt.trim();
			// Test to see if using the "value -> name" type of option
			var namedOptionRegex = /(.+)\->(.+)/g;
			var namedOptionMatch = namedOptionRegex.exec(contents);
			var optionName, optionValue;
			if (namedOptionMatch) {
				optionValue = namedOptionMatch[1].trim();
				optionName = namedOptionMatch[2].trim();
			} else {
				optionName = contents;
				optionValue = contents;
			}
			output += '<option value="' + optionValue + '"' + 
						(match ? ' selected="selected">' : '>') 
						+ optionName + '</option>';
		});
		output += '</select>\n';
		return output;
	});
};

var _CreateVerticalRadioButtonInput = function (text) {
	//
	// Creates a group of radio buttons in vertical list.
	// Converts text of the form:
	//
	// sex || (x) male () female
	//
	// into:
	//
	// <label>Sex:</label>
	// <input type="radio" name="sex" id="male" value="male" checked="checked"/>
	// <label for="male">Male</label>
	// <input type="radio" name="sex" id="female" value="female"/>
	// <label for="female">Female</label>
	//
	// Right now it only works on single-line expressions.
	// 
	// TODO: Make this work across multiple lines.
	//
	var regex = /(\w[\w \t\-]*)\|\|[ \t]*(\(x?\)[ \t]*[\w \t\-\/]+[\(\)\w \t\-\/]*)/g;
	return text.replace(regex, function(whole, name, options) {
		var cleanedName = name.trim().replace(/\t/g, ' ');
		var inputName = cleanedName.replace(/[ \t]/g, '_').toLowerCase();
		var cleanedOptions = options.trim().replace(/\t/g, ' ');
		var labelName = cleanedName + ":";
		var output = '<label>' + labelName + '</label><ol>';
		var optRegex = /\((x?)\)[ \t]*([a-zA-Z0-9 \t_\-\/]+)/g;
		var match = optRegex.exec(cleanedOptions);
		while (match) {
			var id = match[2].trim().replace(/\t/g, ' ').replace(/[ \t]/g, '_').toLowerCase();
			var checkboxLabel = match[2].trim().replace(/\t/g, ' ');
			var checked = match[1] == 'x';
			output += '<li><input type="radio" name="' + inputName + '" id="' + id + 
						'" value="' + id + '" ' + (checked ? 'checked="checked"' : '') + '/>';
			output += '<label for="' + id + '">' + checkboxLabel + '</label></li>';
			match = optRegex.exec(cleanedOptions);
		}
		output += '</ol>';
		return output;
	});
}

var _CreateVerticalCheckboxInput = function (text) {
	//
	// Creates a group of checkboxes.
	// Converts text of the form:
	//
	// phones = [] Android [x] iPhone [x] Blackberry
	//
	// into:
	//
	// <label>Phones:</label> 
	// <input type="checkbox" name="phones" id="Android" value="Android"/>
	// <label for="Android">Android</label>
	// <input type="checkbox" name="phones" id="iPhone" value="iPhone" checked="checked"/>
	// <label for="iPhone">iPhone</label>
	// <input type="checkbox" name="phones" id="Blackberry" value="Blackberry" checked="checked"/>
	// <label for="Blackberry">Blackberry</label>
	//
	// Right now it only works on single-line expressions.
	// 
	// TODO: Make this work across multiple lines.
	//
	var regex = /(\w[\w \t\-]*)\!\![ \t]*(\[x?\][ \t]*[\w \t\-]+[\[\]\w \t\-\/]*)/g;
	return text.replace(regex, function(whole, name, options) {
		var cleanedName = name.trim().replace(/\t/g, ' ');
		var inputName = cleanedName.replace(/[ \t]/g, '_').toLowerCase();
		var cleanedOptions = options.trim().replace(/\t/g, ' ');
		var labelName = cleanedName + ":";
		var output = '<label>' + labelName + '</label><ol>';
		var optRegex = /\[(x?)\][ \t]*([\w \t\-\/]+)/g;
		var match = optRegex.exec(cleanedOptions);
		while (match) {
			var id = match[2].trim().replace(/\t/g, ' ').replace(/[ \t]/g, '_').toLowerCase();
			var checkboxLabel = match[2].trim().replace(/\t/g, ' ');
			var checked = match[1] == 'x';
			output += '<li><input type="checkbox" name="' + inputName + '" id="' + id + 
						'" value="' + id + '" ' + (checked ? 'checked="checked"' : '') + '/>';
			output += '<label for="' + id + '">' + checkboxLabel + '</label></li>';
			match = optRegex.exec(cleanedOptions);
		}
		output += '</ol>';
		return output;
	});
};

var Markdown_Converter = new Markdown.Converter();
Markdown_Converter.hooks.chain("postNormalization", function (text) {
	// Turns "name = ___" into form input element
	text = _CreateFormTextInput(text);

	// Turns expressions like "label = () option 1 () option 2 () option 3" into radio buttons
	text = _CreateRadioButtonInput(text);

	// Turns expressions like "label = [] option 1 [x] option 2 [x] option 3" into checkboxes
	text = _CreateCheckboxInput(text);

	// Turns expressions like "Please select = {option1, option2, (option3)}" into an HTML select
	// form input, with whichever option is in parentheses will be the default selection
	text = _CreateDropdownInput(text);

	// Turns expressions like "label | () option 1 () option 2 () option 3" into radio buttons but in vertical list
	text = _CreateVerticalRadioButtonInput(text);

	// Turns expressions like "label = [] option 1 [x] option 2 [x] option 3" into checkboxes but in vertical list
	text = _CreateVerticalCheckboxInput(text);
	return text;
});
