module.factory 'People', ($resource, api_url) ->
    url = "#{api_url}/peoples"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        get:
            url:             "#{url}/:people_id"
            isArray:         false
            cache:           true
            params:
                people_id: '@people_id'
        getMovies:
            url:             "#{url}/:people_id/movies"
            isArray:         false
            cache:           true
            params:
                people_id: '@people_id'
        getScore:
            url:             "#{url}/:people_id/score"
            isArray:         false
            cache:           true
            params:
                people_id: '@people_id'
        getTop:
            url:             "#{url}/top"
            isArray:         false
            cache:           true

    return $resource url, { }, actions
