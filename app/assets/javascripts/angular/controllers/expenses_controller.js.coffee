finplan.controller 'ExpensesController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->

  $http.get('/expenses.json').success (data) ->
    $scope.expenses = data

  if $routeParams.expenseId
    $http.get('/expenses/'+$routeParams.expenseId+'.json').success (data) ->
      $scope.expense = data
      $scope.curParams = data.params

  $scope.update = (expense) ->
    formData = {
      '_method': 'patch',
      #TODO
    }

    #process the form
    $.ajax({
      type 		: 'POST',
      url 		: '/expenses/'+expense.id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        console.log("success!")
    })
]