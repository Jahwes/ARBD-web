module.factory 'Ticket', ($resource, api_url) ->
    url = "#{api_url}/tickets"

    actions =
        query:
            url:             "#{url}/search"
            isArray:         false
        get:
            url:             "#{url}/:ticket_id"
            isArray:         false
            cache:           true
            param:
                ticket_id: '@ticket_id'

    return $resource url, { }, actions
