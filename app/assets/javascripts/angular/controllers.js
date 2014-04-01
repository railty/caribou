'use strict';

angular.module('templateApp.controllers', [])
.controller('templateCtrl', ['$scope', '$sce', 'Template', function($scope, $sce, Template) {
	
	$scope.init = function(id){
		if (typeof id == "undefined"){
			$scope.template = new Template();
			$scope.template.question = "";
		}
		else{
			$scope.template = Template.get({id: id}, function(template, headers){
				$scope.template = template;
				$scope.setStatus("Success Loaded "+template.id);
			}, function(headers){
				$scope.setStatus("Error: HTTP Status "+headers.status);
			});
		}
  };
	
	$scope.save = function(){
		$scope.setStatus("Saving");
		if (typeof $scope.template.id == "undefined"){
			$scope.template.$save(function(template, headers) {
				$scope.setStatus("Create Success "+template.id);
			},function(headers) {
			 $scope.setStatus("Error: HTTP Status "+headers.status);
			});
		}
		else{
			$scope.template.$update(function(template, headers) {
				$scope.setStatus("Update Success "+template.id);
			},function(headers) {
				$scope.setStatus("Error: HTTP Status "+headers.status);
			});				
		}
	};

	$scope.setStatus = function(msg){
		$scope.status = msg;
	};
	
	$scope.check = function(){
		console.log($('input[name=answers]:checked', 'ol').val());
		$scope.template.$check({});
	};
}]);

