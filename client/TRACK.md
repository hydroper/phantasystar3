# Track

Cleanup the project UI to start fresh.

Goals:

- The UI should be similiar to Phantasy Star Online 2, but bigger for mobile users.

To-do:

- [ ] Reset the pause button appearance. It is not a pause also; should be a hamburguer button.
- [ ] Update the default theme.
- [x] Create `ps3_button`
- [ ] Update `ps3_panel`.
- [ ] UI should be heavily dependent on popup and collapse signals and express dependent panels in a concise way.
- [ ] Accessing items should be similiar to PSO2. A context menu should appear when pressing an item button.

To-do before relying on custom UI components:

- [ ] Animate them to reflect PSO2 UI style. Animations and state skins are usually put in the `XXX_states` first child.
  - [ ] Not all effects will be implemented at first, but it can be polished later.

## PSO2 references

- Gameplay: https://youtu.be/jz92sYbwIKw?t=8

## Implemented UI

- [ ] UI components
  - [x] Button
  - [ ] Panel
- [ ] Gameplay
  - [ ] Menu (bottom-bar similiar to PSO2)
    - [ ] https://youtu.be/jz92sYbwIKw?t=1318
    - [ ] Items
    - [ ] Character
      - [ ] Tech
      - [ ] Equipment
        - [ ] Item context menu allows to unequip and equip
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