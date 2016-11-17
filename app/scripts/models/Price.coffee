module.factory 'Price', ($resource, api_url) ->
    url = "#{api_url}/prices"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        getCurrent:
            url:             "#{url}/current"
            isArray:         false
            cache:           true

    return $resource url, { }, actions
