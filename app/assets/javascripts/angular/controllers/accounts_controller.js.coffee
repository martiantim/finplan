finplan.controller 'AccountsController', ['$scope', '$routeParams', '$location', '$http', ($scope, $routeParams, $location, $http) ->

  $http.get('/accounts.json').success (data) ->
    $scope.accounts = data

  $http.get('/accounts/investment_types.json').success (data) ->
    $scope.investmentTypes = data

  $http.get('/accounts/account_types.json').success (data) ->
    $scope.accountTypes = data

  if $routeParams.accountId
    $http.get('/accounts/'+$routeParams.accountId+'.json').success (data) ->
      $scope.account = data
      $scope.curParams = data.params

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