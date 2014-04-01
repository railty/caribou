'use strict';

angular.module('templateApp', [
	'ngResource', 
	'ngSanitize', 
	'templateApp.filters',
	'templateApp.services',
	'templateApp.factories',
	'templateApp.controllers'
])
 .config(['$httpProvider', function($httpProvider){
  $httpProvider.defaults.headers.common = {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'), 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest'};
}]);


