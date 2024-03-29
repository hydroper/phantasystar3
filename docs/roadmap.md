# Roadmap

## Current Tasks

`Character > Tech`

## PSO2 references

- Gameplay: https://youtu.be/jz92sYbwIKw?t=8

## Implemented

- [x] Overworld party
- [x] Intro screen
  - [ ] Story (update `_skip_part` in that case)
- [ ] Main Menu
  - [ ] New Game
    - [ ] Set the game data slot to the last one + 1.
- [ ] Gameplay
  - [ ] Automatically save game on story progress
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
      - [x] Party Order
      - [ ] Macro
        - [ ] Items that target someone at party, target by type, not by their unique identity.
      - [ ] Talk
      - [ ] System
        - [ ] Save Game
          - [ ] If a different slot is chosen, the current gameplay will use that slot.
      - [x] Log Out

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