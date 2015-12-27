finplan.controller 'ExpensesController', ['$scope', '$routeParams', '$location', '$http', 'plan', ($scope, $routeParams, $location, $http, plan) ->

  $scope.loadExpense = (id) ->
    $scope.selectedExpenseId = id
    $http.get('/expenses/'+id+'.json').success (data) ->
      $scope.expense = data
      $scope.curParams = data.params

  $http.get('/expenses.json').success (data) ->
    $scope.expenses = data
    $scope.loadExpense(data[0].id) if !$routeParams.expenseId

  if $routeParams.expenseId
    $scope.loadExpense($routeParams.expenseId)

  $scope.reloadList = (loadFirst) ->
    $http.get('/expenses.json').success (data) ->
      delete $scope.expenses
      $scope.expenses = data
      $scope.loadExpense(data[0].id) if loadFirst

  $scope.remove = (expense) ->
    $.ajax({
      url: "/expenses/#{expense.id}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        $scope.$apply ->
          $scope.reloadList(true)
          plan.markDirty(true)
    })

  $scope.update = (expense) ->
    formSaving()
    console.log(expense)
    formData = {
      'manipulator[name]': expense.name
      'manipulator[manipulator_template_id]': expense.manipulator_template_id
      'manipulator[plan_id]': expense.plan_id
    }
    for param in $scope.curParams
      formData["variables[#{param.name}]"] = param.value

    if expense.id
      formData['_method'] = 'patch'
      formData['manipulator[id]'] = expense.id

    id = ''
    id = expense.id if expense.id
    $.ajax({
      type 		: 'POST',
      url 		: '/expenses/'+id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        plan.markDirty(true)
        formSuccess()
        console.log("success!")
    })
]