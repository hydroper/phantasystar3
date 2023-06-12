class_name PS3Messages

# Returns a BBCode string
static func tech_result(result: Dictionary) -> String:
    if result.type == "not_enough_tp":
        return "Not enough TP."
    elif result.type == "restored_hp":
        return "Restored [b]" + str(result.restored_hp) + " HP[/b] for " + result.party_char.name + "."
    elif result.type == "restored_tp":
        return "Restored [b]" + str(result.restored_tp) + " TP[/b] for " + result.party_char.name + "."
    elif result.type == "hp_already_full":
        return "HP is already full."
    else:
        return "undefined"
