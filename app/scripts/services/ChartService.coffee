module.factory 'ChartService', (
    Search
    NotifyService
    People
) ->
    class Creator
        getAgeRange: (config) ->
            body =
                aggs:
                    range_age:
                        range:
                            field: 'age'
                            ranges: [
                                { key: '-18',             to: 18 }
                                { key: '18-25', from: 19, to: 25 }
                                { key: '25-39', from: 25, to: 40 }
                                { key: '40-45', from: 40, to: 45 }
                                { key: '45-55', from: 45, to: 55 }
                                { key: '55+',   from: 55 }
                            ]
            Search
            .search { entity: 'spectator' }, body
            .$promise
            .then (ageRanged) ->
                datas   = []
                buckets = ageRanged.aggregations.range_age.buckets
                for bucket in buckets
                    datas.push
                        name: bucket.key
                        y:    bucket.doc_count
                config.title.text = 'Spectator by Ages'
                config.series[0].data = datas
                config.loading = false
                return config
            .catch (err) ->
                NotifyService.pushError
                    title:     'ES'
                    content:   'ES'
                    api_error: err

        getGender: (config) ->
            body =
                aggs:
                    count_by_type:
                        terms:
                            field: 'title'
                size: 0
            Search
            .search { entity: 'spectator' }, body
            .$promise
            .then (genderPart) ->
                datas   = []
                gender  = ''
                buckets = genderPart.aggregations.count_by_type.buckets
                for bucket in buckets
                    switch bucket.key
                        when 'mademoiselle'
                            gender = 'Single women, we know you kevin !'
                        when 'madame'
                            gender = 'Women'
                        when 'monsieur'
                            gender = 'Men'
                    datas.push
                        name: gender
                        y:    bucket.doc_count
                config.title.text = 'Men/Women repartition'
                config.series[0].data = datas
                config.loading = false
                return config
            .catch (err) ->
                NotifyService.pushError
                    title:     'ES'
                    content:   'ES'
                    api_error: err
        getFilmStats: (config) ->
            body =
                aggs:
                    count_by_movie_title:
                        terms:
                            field: 'movie_title'
                            size: 9999
                size: 0
            Search
            .search { entity: 'ticket' }, body
            .$promise
            .then (filmStats) ->
                buckets = filmStats.aggregations.count_by_movie_title.buckets
                datas   = []
                for bucket in buckets
                    datas.push
                        name: bucket.key
                        y:    bucket.doc_count
                config.title.text = 'Film popularity'
                config.series[0].data = datas
                config.loading = false
                return config
            .catch (err) ->
                NotifyService.pushError
                    title:     'ES'
                    content:   'ES'
                    api_error: err

        getCompanyStats: (config) ->
            body =
                aggs:
                    count_by_company:
                        terms:
                            field: 'company'
                            size: 9999
                size: 0
            Search
            .search { entity: 'ticket' }, body
            .$promise
            .then (filmStats) ->
                buckets = filmStats.aggregations.count_by_company.buckets
                datas   = []
                for bucket in buckets
                    datas.push
                        name: bucket.key
                        y:    bucket.doc_count
                config.title.text = 'Tickets by company'
                config.series[0].data = datas
                config.loading = false
                return config
            .catch (err) ->
                NotifyService.pushError
                    title:     'ES'
                    content:   'ES'
                    api_error: err

        getDateStats: (config) ->
            body =
                aggs:
                    count_by_date:
                        terms:
                            field: 'showing_date'
                            size: 60
                size: 0
            Search
            .search { entity: 'ticket' }, body
            .$promise
            .then (dateStats) ->
                buckets = dateStats.aggregations.count_by_date.buckets
                datas   = []
                for bucket in buckets
                    datas.push
                        name: bucket.key
                        y:    bucket.doc_count
                config.title.text = 'Most popular date'
                config.series[0].data = datas
                config.loading = false
                return config
            .catch (err) ->
                NotifyService.pushError
                    title:     'ES'
                    content:   'ES'
                    api_error: err

        getFilmStats3D: (config) ->
            body =
                aggs:
                    count_by_movie_title:
                        terms:
                            field: 'movie_title'
                            size: 9999
                        aggs:
                            count_3D:
                                terms:
                                    field: 'is_3D'
                                    size: 9999
                size: 0
            Search
            .search { entity: 'ticket' }, body
            .$promise
            .then (filmStats) ->
                buckets = filmStats.aggregations.count_by_movie_title.buckets
                datas   = []
                for bucket in buckets
                    name = bucket.key
                    buckets_3D = bucket.count_3D.buckets
                    for bucket_3D in buckets_3D
                        if 'T' is bucket_3D.key
                            datas.push
                                name: "#{bucket.key} 3D"
                                y:    bucket_3D.doc_count
                        else
                            datas.push
                                name: "#{bucket.key} 2D"
                                y:    bucket_3D.doc_count
                config.title.text = 'Films 2D/3D'
                config.series[0].data = datas
                config.loading = false
                return config
            .catch (err) ->
                NotifyService.pushError
                    title:     'ES'
                    content:   err
                    api_error: err
