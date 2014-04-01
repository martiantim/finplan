finplan.controller 'AccountsController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->
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

  if $routeParams.accountId
    $scope.loadAccount($routeParams.accountId)

  $scope.update = (account) ->
    formData = {
      '_method': 'patch',
      'account[id]': account.id,
      'account[name]': account.name
    }

    #process the form
    $.ajax({
      type 		: 'POST',
      url 		: '/accounts/'+account.id,
      data 		: formData,
      dataType: 'json',
      success : (data) ->
        console.log("success!")
    })
]