module.controller 'HomeCtrl', ($rootScope, $scope, Order, $state, NotifyService) ->
    $scope.orders      = []
    $scope.pagedOrders = []
    $scope.query       = ''

    $scope.pagination =
        currentPage: 1

    $scope.fetchOrders = (query = '*') ->
        return if query is $scope.query
        $scope.query = query
        Order
        .query
            size:  9999
            from:  0
            query: $scope.query
        .$promise
        .then (Orders) ->
            $scope.orders = Orders.hits
            $scope.getPage()
            $scope.pagination.totalItems = $scope.orders.length
        .catch (api_error) ->
            NotifyService.pushError
                title:     'Liste des commandes'
                content:   'Une erreur est survenue durant le chargement des commandes'
                api_error: api_error

    $scope.getPage = ->
        max = $scope.pagination.currentPage * 20
        min = max - 20
        $scope.pagedOrders = $scope.orders.slice min, max

    $scope.fetchOrders()

    $scope.$watch 'currentPage', $scope.getPage()
