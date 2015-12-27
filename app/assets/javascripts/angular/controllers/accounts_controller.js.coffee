finplan.controller 'AccountsController', ['$scope', '$routeParams', '$location', '$http', 'plan', ($scope, $routeParams, $location, $http, plan) ->
  $scope.loadAccount = (accountId) ->
    $scope.selectedAccountId = accountId
    $http.get('/accounts/'+accountId+'.json').success (data) ->
      $scope.account = data
      $scope.curParams = data.params
      finFormat($('.content_main'), 100)

  $http.get('/accounts.json').success (data) ->
    $scope.accounts = data
    $scope.loadAccount(data[0].id) if !$routeParams.accountId

  $http.get('/accounts/investment_types.json').success (data) ->
    $scope.investmentTypes = data

  $http.get('/accounts/account_types.json').success (data) ->
    $scope.accountTypes = data
    console.log("type")
    console.log($scope.accountTypes)

  if $routeParams.accountId
    $scope.loadAccount($routeParams.accountId)

  $scope.reloadList = (loadFirst) ->
    $http.get('/accounts.json').success (data) ->
      delete $scope.accounts
      $scope.accounts = data
      $scope.loadAccount(data[0].id) if loadFirst

  $scope.remove = (account) ->
    $.ajax({
      url: "/accounts/#{account.id}",
      type: 'POST',
      data: {'_method': 'delete'},
      success: (data) ->
        $scope.$apply ->
          $scope.reloadList(true)
          plan.markDirty(true)
    })

  $scope.update = (account) ->
    formSaving()
    formData = {
      'account[name]': account.name,
      'account[plan_id]': account.plan_id,
      'account[balance]': $('input[name="balance"]').val(),
      'account[investment_type]': account.investment_type,
      'account[interest_rate]': $('input[name="interest_rate"]').val(),
      'account[term]': account.term
      'account[limit]': account.limit
    }
    if account.id
      formData['_method'] = 'patch'
      formData['account[id]'] = account.id

    #process the form
    id = ''
    id = account.id if account.id
    $.ajax({
      type 		: 'POST',
      url 		: '/accounts/'+id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        formSuccess()
        $scope.reloadList()
        plan.markDirty(true)
    })
]