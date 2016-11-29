module.factory 'Search', ($resource, es_url, index) ->
    url = "#{es_url}/#{index}/:entity"
    params =
        entity: '@entity'

    actions =
        query:
            method:  'GET'
            url:     "#{url}"
            isArray: false
        search:
            method:  'POST'
            url:     "#{url}/_search"
            isArray: false

    return $resource url, { }, actions
