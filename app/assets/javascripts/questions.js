function renderQuestion(selector){
	selector.each(function(){
		$(this).html(Markdown_Converter.makeHtml($(this).html()));		
	});
}

$(document).ready(function(){
    $("#tooltip").tooltip();
});