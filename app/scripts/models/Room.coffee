module.factory 'Room', ($resource, api_url) ->
    url = "#{api_url}/rooms"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        get:
            url:             "#{url}/:room_id"
            isArray:         false
            cache:           true
            param:
                room_id: '@room_id'

    return $resource url, { }, actions
