module.factory 'NotifyService', (Notification) ->
    return new class Notify
        constructor: ->
            @errors = []

        notify: (message) ->
            Notification
                message: message
                delay:   2500
            , 'success'

        pushError: (error) ->
            error.type = if error.api_error.status >= 500 then 'error' else 'warning'

            @errors.splice 0, 0, angular.extend(error, { date: moment() })

            Notification
                message: error.content
                delay:   2500
            , error.type

        getErrors: ->
            errors  = @errors
            @errors = []
            return errors
