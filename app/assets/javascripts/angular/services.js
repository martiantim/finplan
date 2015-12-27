/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('FinPlan.services', []).
  value('version', '0.1');

finplan.factory('plan', function($http) {
  var plan = new Plan(window.plan_id, window.plan_name);
  plan.reloadData($http);

  return plan;
});

