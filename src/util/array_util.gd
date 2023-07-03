class_name ArrayUtil

static func to_reversed(array: Array) -> Array:
    var r = array.slice(0)
    r.reverse()
    return r

static func to_sorted(array: Array, callback_fn: Callable) -> Array:
    var r = array.slice(0)
    r.sort_custom(callback_fn)
    return r
