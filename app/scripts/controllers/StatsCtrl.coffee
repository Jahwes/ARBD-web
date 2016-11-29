module.controller 'StatsCtrl', ($rootScope, $scope, ChartService, People) ->
    chartConfig = {
        options: {
            chart: {
                type: 'pie'
            }
        },
        series: [{
            data: [10, 15, 12, 8, 7]
        }],
        title: {
            text: 'title'
        },
        loading: false
    }
    $scope.chartConfig = chartConfig
    chart = new ChartService

    $scope.changeType = (type) ->
        $scope.chartConfig.options.chart.type = type
    $scope.ageStats = ->
        $scope.chartConfig.loading = true
        chart
        .getAgeRange(chartConfig)
        .then (config) ->
            $scope.chartConfig = config

    $scope.genderStats = ->
        $scope.chartConfig.loading = true
        chart
        .getGender(chartConfig)
        .then (config) ->
            $scope.chartConfig = config

    $scope.popularFilms = ->
        $scope.chartConfig.loading = true
        chart
        .getFilmStats(chartConfig)
        .then (config) ->
            $scope.chartConfig = config

    $scope.popularDates = ->
        $scope.chartConfig.loading = true
        chart
        .getDateStats(chartConfig)
        .then (config) ->
            $scope.chartConfig = config

    $scope.companyStats = ->
        $scope.chartConfig.loading = true
        chart
        .getCompanyStats(chartConfig)
        .then (config) ->
            $scope.chartConfig = config

    $scope.filmStats3D = ->
        $scope.chartConfig.loading = true
        chart
        .getFilmStats3D(chartConfig)
        .then (config) ->
            $scope.chartConfig = config

    $scope.topActors = (type = 'both') ->
        People
        .getTop { type: type }
        .$promise
        .then (actors) ->
            datas = []
            for actor, y of actors.top
                datas.push
                    name: actor
                    y:    y
            switch type
                when 'actrice'
                    $scope.chartConfig.title.text = 'Actress'
                when 'acteur'
                    $scope.chartConfig.title.text = 'Actors'
                when 'both'
                    $scope.chartConfig.title.text = 'Both actors/actress'

            $scope.chartConfig.series[0].data = datas
            $scope.chartConfig.loading = false
        .catch (err) ->
            NotifyService.pushError
                title:     'ES'
                content:   'ES'
                api_error: err

    $scope.ageStats(chartConfig)
