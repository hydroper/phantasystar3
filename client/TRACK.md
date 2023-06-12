# Track

Cleanup the project UI to start fresh.

Goals:

- The UI should be similiar to Phantasy Star Online 2, but bigger for mobile users.

To-do:

- [ ] Apply Roboto font everywhere in the default theme.
- [ ] Reset the pause button appearance.
- [ ] Update the default theme.
- [ ] Update `ps3_default_panel`.
- [ ] Create `ps3_default_panel_with_header`.
- [ ] UI should be heavily dependent on popup and collapse signals and express dependent panels in a concise way.
- [ ] Accessing items should be similiar to PSO2. A context menu should appear when pressing an item button.

To-do before relying on custom UI components:

- [ ] Animate them to reflect PSO2 UI style. If that is not done early, the component children can break compatibility later.

## PSO2 references

- Gameplay: https://youtu.be/jz92sYbwIKw?t=8

## Implemented UI

- [ ] Gameplay
  - [ ] Menu (bottom-bar similiar to PSO2)
    - [ ] https://youtu.be/jz92sYbwIKw?t=1318
    - [ ] Items
    - [ ] Character
      - [ ] Equipment
        - [ ] Item context menu allows unequip and equip
    - [ ] Party Order
    - [ ] Macro
    - [ ] Talk
    - [ ] System
    - [ ] Log Out