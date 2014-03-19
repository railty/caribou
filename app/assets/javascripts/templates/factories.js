'use strict';

/* Factories */

angular.module('templateApp.factories', [])
.factory('Template', ['$resource', function($resource) {
    return $resource('/templates/:id', {
      id: '@id'
    }, {
      update: {method:'PUT'}
    });
  }
]);
