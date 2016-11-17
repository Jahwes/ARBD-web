module.factory 'User', ($resource, api_url) ->
    url = "#{api_url}/users"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        get:
            url:             "#{url}/:user_id"
            isArray:         false
            cache:           true
            param:
                user_id: '@user_id'

        getOrders:
            url:             "#{url}/:user_id/orders"
            isArray:         false
            cache:           true
            param:
                user_id: '@user_id'

    return $resource url, { }, actions
