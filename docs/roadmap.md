# Roadmap

## Current Tasks

`Character > Tech`

## PSO2 references

- Gameplay: https://youtu.be/jz92sYbwIKw?t=8

## Godot

- [ ] Check if HTML5 Unicode rendering issue is fixed for special characters such as multiplication sisgn. And check if the system font fallbacks are necessary: if not, then remove them for each custom font.

## Implemented

- [ ] Gameplay
  - [ ] During progress, ask whether to save game. This may be useful if the player forgets going to `System > Save Game`
  - [ ] Menu
    - [ ] Local Shop
      - [ ] For weapons or armor, display which characters can equip the item and the status compared to the current equipment.
    - [ ] Main Menu
      - https://youtu.be/jz92sYbwIKw?t=1318
      - [x] Items
      - [x] Character
        - [x] Equipment
          - https://youtu.be/jz92sYbwIKw?t=1238
        - [x] Tech
      - [ ] Party Order
      - [ ] Macro
      - [ ] Talk
      - [ ] System
      - [ ] Log Out
        - [ ] Ask before exiting game. If exitting, return to the intro.

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