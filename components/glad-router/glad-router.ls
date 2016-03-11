{filter, find, map, elem-index, each, reject, tail, lists-to-obj} = Polymer.GladPreludeLs
elms = []

class RouteMatcher
  (@route)->
  regex_str:~ -> "^#{
    @route.path
      .replace(/\//g, "\\/")
      .replace(/\*/g, ".*")
      .replace(/:[^/]+/g, "([^/]*)")
    }$"
  regex:~ -> RegExp @regex_str
  param_keys:~ -> if @route.path.match /:[^/]+/g then that |> map tail else []
  params_from: (str)->
    if @regex.exec str
      that
      |> tail
      |> ~>
        lists-to-obj @param_keys, it
    else {}
  match: (str)-> @regex.test str

class GladRouter
  is: \glad-router
  properties:
    prev-route:
      type: Object
      notify: on
    prev-params:
      type: Object
      notify: on
    current-route:
      type: Object
      notify: on
    current-params:
      type: Object
      notify: on
  observers: [
    "initialize_on_changed(routes)"
    "set_route_on_changed(hash)"
    "set_params_on_changed(hash)"
  ]
  _get_meta: (key)-> @$.meta.by-key key
  _set_meta: (key, value)-> @$.meta._register-key-value key, value
  initialize_on_changed: (routes)->
    if not routes? then return
    @_set_meta \routes, routes
    @_set_meta \matchers, (routes |> map (-> new RouteMatcher it))
    @set_route!
    @set_params!
  set_route_on_changed: (hash)-> @set_route!
  set_params_on_changed: (hash)-> @set_params!
  set_route: ->
    if not @hash? or not (@_get_meta \matchers)? then return
    (@_get_meta \matchers)
    |> find ~>
      | @hash.length is 0 => it.match @path
      | _ => it.match @hash
    |> ({route}?)~>
      @_set_meta \prevRoute, prev_route = @current-route
      @_set_meta \currentRoute, route
      elms |> each ~>
        it.set \prevRoute, prev_route
        it.set \currentRoute, route
  set_params: ->
    if not @current-route? or not (@_get_meta \matchers)? then return
    (@_get_meta \matchers)
    |> find ({route})~> route is @current-route
    |> (matcher)~>
      @_set_meta \prevParams, prev_params = @current-params
      @_set_meta \currentParams, (params = matcher.params_from @hash)
      elms |> each ~>
        it.set \prevParams, prev_params
        it.set \currentParams, params
  created: ->
    elms.push @
  ready: ->
    @set \prevRoute, @_get_meta \prevRoute
    @set \prevParams, @_get_meta \prevParams
    @set \currentRoute, @_get_meta \currentRoute
    @set \currentParams, @_get_meta \currentParams
    if (@_get_meta \first_elm)? then return
    @_set_meta \first_elm, @
    @set \is_first_elm, yes

|> ( .::) |> Polymer


