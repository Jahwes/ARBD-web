module.controller 'PriceModalCtrl', (
    $scope
    $uibModalInstance
    $previousState
    $state
    Price
    NotifyService
) ->
    $scope.fetchPrices = ->
        Price
        .getCurrent { }
        .$promise
        .then (prices) ->
            $scope.actual_prices = prices
        .catch (api_error) ->
            NotifyService
            .pushError
                title:     'Liste des commandes'
                content:   'Une erreur est survenue durant le chargement des commandes'
                api_error: api_error

    $scope.types = [
        'Tarif reduit'
        'Senior'
        'Plein tarif'
        'Tarif etudiant'
    ]

    $scope.prices_to_push = []

    $scope.putPrices = ->
        return if '' is $scope.price_type and '' is $scope.price_value
        Price
        .addPrice { }, { type: $scope.price_type, value: parseFloat($scope.price_value) }
        .$promise
        .then (result) ->
            $scope.fetchPrices()
        .catch (api_error) ->
            NotifyService.pushError
                title:     'Ajout de nouveau prix'
                content:   'Une erreur est survenue durant l\'ajout de nouveau prix'
                api_error: api_error

    $scope.fetchPrices()
