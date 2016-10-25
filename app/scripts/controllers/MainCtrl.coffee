module.controller 'MainCtrl', ($rootScope, $scope, $state, deviceDetector) ->
    $rootScope.deviceDetector      = deviceDetector

    $scope.init = ->
        $(window, '.wrapper').off 'resize'
        return null

    $scope.menuSwipe = (add_class, remove_class) ->
        if deviceDetector.os is 'ios' or deviceDetector.os is 'android' or deviceDetector.os is 'blackberry'
            $('body').removeClass("sidebar-#{remove_class}")
            $('body').addClass("sidebar-#{add_class}")
        return false
