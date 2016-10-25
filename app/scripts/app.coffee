'use strict'

module = angular.module 'arbd', [
    'arbd-templates',
    'ngSanitize',
    'ui.router',
    'ngAnimate',
    'angular.filter',
    'ng.deviceDetector',
    'truncate',
    'ct.ui.router.extras',
    'ui.select',
    'checklist-model',
    'ui-notification',
    'textAngular',
    'angular-inview'
]

module.config (
    $stateProvider,
    $urlRouterProvider,
    $httpProvider,
    $sceDelegateProvider,
    $compileProvider,
    $urlMatcherFactoryProvider,
) ->
    # on envoie le cookie sur toute nos requetes http par défaut
    $httpProvider.defaults.withCredentials = true

    $compileProvider.aHrefSanitizationWhitelist /^\s*(https?|ftp|mailto|file|tel):/

    # trix pour faire sur n'importe quel number .round(qqchose)
    Number.prototype.round = (places) ->
        return +(Math.round(this + 'e+' + places)  + 'e-' + places)

    moment.locale 'fr'

    # on whitelist les différents domaines etna
    whiteList = $sceDelegateProvider.resourceUrlWhitelist()
    whiteList.push '.*\.dev'

    $urlMatcherFactoryProvider.strictMode(false)

    # Black Magic, touch this and i kill you in your bed
    # ça remplace 'MonResolve' par ['MonResolve', (a) -> a() ]
    getResolvers = (dict) ->
        for key, value of dict
            dict[key] = [ value, (a) -> a() ]
        dict

    $stateProvider
        .state 'app',
            url: ''
            abstract: true
            templateUrl: 'views/layouts/main.html'

        .state 'app.base',
            url: ''
            abstract: true
            views:
                'menu-top':
                    templateUrl: 'views/menu/top.html'
                    controller: 'MenuTopCtrl'
                'menu-left':
                    templateUrl: 'views/menu/movies.html'
                    controller: 'MenuMoviesCtrl'

        .state 'home',
            url: '/'
            parent: 'app.base'
            views:
                'content@app':
                    templateUrl: 'views/home.html'

    $urlRouterProvider.otherwise '/'

module.run ($rootScope, $state, $stateParams) ->
    $rootScope.$state       = $state
    $rootScope.$stateParams = $stateParams

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
        $('.page-loading').addClass('hidden')

