module.controller 'HomeCtrl', ($rootScope, $scope, Movie, $state) ->
    $scope.Movies = null

    Movie
    .query
        size:  100
        from:  0
        query: '*'
    .$promise
    .then (Movies) ->
        $scope.Movies = Movies
    .catch (api_error) ->
        NotifyService.pushError
            title:     'Liste des commandes'
            content:   'Une erreur est survenue durant le chargement des commandes'
            api_error: api_error
