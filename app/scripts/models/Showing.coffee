module.factory 'Showing', ($resource, api_url) ->
    url = "#{api_url}/showings"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        get:
            url:             "#{url}/:showing_id"
            isArray:         false
            cache:           true
            param:
                showing_id: '@showing_id'

        getTickets:
            url:             "#{url}/:showing_id/tickets"
            isArray:         false
            cache:           true
            param:
                showing_id: '@showing_id'

    return $resource url, { }, actions
