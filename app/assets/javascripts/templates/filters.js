'use strict';

/* Filters */

angular.module('templateApp.filters', [])
.filter('toHtml', ['$sce', function($sce) {
	return function(markdown) {
		if (typeof(markdown) != "undefined"){
			return $sce.trustAsHtml(Markdown_Converter.makeHtml(markdown));
		}
	}
}])
.filter('toTrusted', ['$sce', function($sce){
	return function(text) {
		return $sce.trustAsHtml(text);
	}
}]);