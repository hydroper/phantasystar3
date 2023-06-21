# Track

## Current Tasks

`Character > Tech`

## PSO2 references

- Gameplay: https://youtu.be/jz92sYbwIKw?t=8

## Implemented

- [ ] Gameplay
  - [ ] During progress, ask whether to save game. This may be useful if the player forgets going to `System > Save Game`
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

## Accessibility

- Default keyboard keys:
  - ASDW or arrows for UI directions and character movement
  - J, Z, Space or Enter for OK
  - K, X or Escape for cancel
  - P or Escape for pause
- Support touchscreen, keyboard and controller.
- Consider using the `ui_accept` action.

## To avoid UI bugs

- Forget to not call `grab_focus()` on `PS3SelectableItemButton`. Instead do `get_node("button").grab_focus()`.
- Base animated panels re-enable their controls on popup. Separate a function for disabling the necessary controls.
- Panels can be temporarily disabled due to a nested panel. When that nested panel collapses, disable what is necessary again after getting back to the other panels.