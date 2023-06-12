class_name PS3Messages

# Returns BBCode string
static func tech_result(result: Variant) -> String:
    if result.type == "not_enough_tp":
        return "Not enough TP."
    elif result.type == "restored_hp":
        return "Restored " + str(result.restored_hp) + " HP for " + result.party_char.name + "."
    elif result.type == "restored_tp":
        return "Restored " + str(result.restored_tp) + " TP for " + result.party_char.name + "."
    elif result.type == "hp_already_full":
        return "HP is already full."
    else:
        return "Result is unimplemented"