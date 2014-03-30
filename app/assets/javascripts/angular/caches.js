finplan.factory('goalsCache', function($cacheFactory) {
  return $cacheFactory('goalsData');
});
finplan.factory('planCache', function($cacheFactory) {
  return $cacheFactory('planData');
});