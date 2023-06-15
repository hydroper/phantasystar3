# Track

## Bugs to fix now and changes to do now

- [ ] Rename "root menu" to "main menu"

## PSO2 references

- Gameplay: https://youtu.be/jz92sYbwIKw?t=8

## Implemented UI

- [ ] UI Components
  - [ ] Secondary button (similiar to the "Back" button in various PSO2 UI panels)
- [ ] Gameplay
  - [ ] Menu
    - [ ] Local Shop
      - [ ] For weapons or armor, display which characters can equip the item and the status compared to the current equipment.
    - [ ] Main Menu
      - [ ] https://youtu.be/jz92sYbwIKw?t=1318
      - [ ] Items
      - [ ] Character
        - [ ] Equipment
          - https://youtu.be/jz92sYbwIKw?t=1238
          - [ ] Implement "Equip" button (invoke `_update_items()` after data mutation and collapse context menu)
          - [ ] Implement "Unequip" button (invoke `_update_items()` after data mutation and collapse context menu)
        - [ ] Tech
      - [ ] Party Order
      - [ ] Macro
      - [ ] Talk
      - [ ] System
      - [ ] Log Out

## Controls

- For every root control, assign the default theme at the root control:
  - [x] Button

## UI focusing

- [ ] Prevent two buttons from being hovered or focused at the same time.

## Performance and quality

- [ ] On `src/screens/game/menu/game_sc_menu.gd`, replace `is_open`'s return by using a cached variable instead of `$root/sub.has_node("root")` (that requires a lookup in the scene).

## To avoid UI bugs

- Forget to not call `grab_focus()` on `PS3SelectableItemButton`. Instead do `get_node("button").grab_focus()`.