module.controller 'MenuMoviesCtrl', ($scope, $state, Movie, NotifyService) ->
    $scope.movies = []

    Movie
    .query
        size:  9999
        from:  0
        query: '*'
    .$promise
    .then (Movies) ->
        $scope.movies = Movies.hits
    .catch (api_error) ->
        NotifyService.pushError
            title:     'Liste des commandes'
            content:   'Une erreur est survenue durant le chargement des commandes'
            api_error: api_error
