module.factory 'Movie', ($resource, api_url) ->
    url = "#{api_url}/movies"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false

        get:
            url:             "#{url}/:movie_id"
            isArray:         false
            cache:           true
            params:
                movie_id: '@movie_id'

        getShowings:
            url:             "#{url}/:movie_id/showings"
            isArray:         false
            cache:           true
            params:
                movie_id: '@movie_id'

        getPeoples:
            url:             "#{url}/:movie_id/peoples"
            isArray:         false
            cache:           true
            params:
                movie_id: '@movie_id'

        getTypes:
            url:             "#{url}/:movie_id/types"
            isArray:         false
            cache:           true
            params:
                movie_id: '@movie_id'

    return $resource url, { }, actions
