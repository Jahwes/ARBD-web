module.factory 'Order', ($resource, api_url) ->
    url = "#{api_url}/orders"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        get:
            url:             "#{url}/:order_id"
            isArray:         false
            cache:           true
            params:
                order_id: '@order_id'
        getTickets:
            url:             "#{url}/:order_id/tickets"
            isArray:         false
            cache:           true
            params:
                order_id: '@order_id'

    return $resource url, { }, actions
