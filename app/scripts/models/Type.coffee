module.factory 'Type', ($resource, api_url) ->
    url = "#{api_url}/types"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        get:
            url:             "#{url}/:type_id"
            isArray:         false
            cache:           true
            param:
                type_id: '@type_id'

    return $resource url, { }, actions
