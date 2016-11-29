module.controller 'MenuTopCtrl', ($scope, $state, $location, $uibModal, Price, NotifyService) ->
    $scope.openPriceModal = ->
        modal_instance = $uibModal.open
            templateUrl: 'views/modals/price_modal.html'
            controller:  'PriceModalCtrl'
            size:        'lg'

    $scope.openStats = ->
        $location.path('/stats')
