# Track

## Current Tasks

`Character > Tech`

## PSO2 references

- Gameplay: https://youtu.be/jz92sYbwIKw?t=8

## Implemented

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