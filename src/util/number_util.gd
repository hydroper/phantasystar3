class_name NumberUtil

static func comma_sep(number: Variant) -> String:
    var string = str(number)
    var mod = string.length() % 3
    var res = ""
    for i in range(0, string.length()):
        if i != 0 and i % 3 == mod:
            res += ","
        res += string[i]
    return res
