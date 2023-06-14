# Track

Cleanup the project UI to start fresh.

Goals:

- The UI should be similiar to Phantasy Star Online 2, but bigger for mobile users.

To-do:

- [ ] Reset the pause button appearance. It is not a pause also; should be a hamburguer button.
- [ ] Update the default theme.
- [ ] UI should be heavily dependent on popup and collapse signals and express dependent panels in a concise way.
- [ ] Accessing items should be similiar to PSO2. A context menu should appear when pressing an item button.

To-do before relying on custom UI components:

- [ ] Animate them to reflect PSO2 UI style. Animations and state skins are usually put in the `XXX_states` first child.
  - [ ] Not all effects will be implemented at first, but it can be polished later.

## PSO2 references

- Gameplay: https://youtu.be/jz92sYbwIKw?t=8

## Implemented UI

- [ ] UI Components
  - [ ] Secondary button (similiar to the "Back" button in various PSO2 UI panels)
- [ ] Gameplay
  - [ ] Menu (bottom-bar similiar to PSO2)
    - [ ] https://youtu.be/jz92sYbwIKw?t=1318
    - [ ] Items
    - [ ] Character
      - [ ] Equipment
        - https://youtu.be/jz92sYbwIKw?t=1238
        - [ ] Focus item on popup.
        - [ ] Focus item after closing context menu.
        - [ ] Focus item after
        - [ ] Display the "equipped" indicator on `PS3SelectableItemButton` if the item is equipped, by changing its `is_equipped` property.
        - [ ] Item context menu allows to unequip and equip
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