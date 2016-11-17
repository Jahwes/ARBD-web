module.factory 'Spectator', ($resource, api_url) ->
    url = "#{api_url}/spectators"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        get:
            url:             "#{url}/:spectator_id"
            isArray:         false
            cache:           true
            param:
                spectator_id: '@spectator_id'

    return $resource url, { }, actions
