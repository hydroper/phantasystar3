extends Node2D

var game_state := GameState.new()
var in_battle: bool = false
var paused: bool = false

@onready var pause_panel = $root/pause_panel

@onready var inventory_panel = $root/inventory_panel
@onready var inventory_item_panel = $root/inventory_item_panel
var inventory_item_panel___selected_button = null
var inventory_item_panel___selected_item: InventoryItem = null
var inventory_item_panel___description_index = 0

@onready var leave_game_panel = $root/leave_panel

@onready var bottom_message_box = $root/bottom_message_box
@onready var bottom_message_box_over_ui = $root/bottom_message_box_over_ui

# collapse-priority-based Array of panels
var pause_related_panels = []
var pause_related_panels_but_no_root_panel = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_related_panels = [
		inventory_item_panel,
		inventory_panel,
		leave_game_panel,
		pause_panel,
	]
	pause_related_panels_but_no_root_panel = pause_related_panels.filter(func(p): return p != pause_panel)

	bottom_message_box_over_ui.after_collapse.connect(func(goal):
		if goal == "inventory_look_button":
			$root/inventory_item_panel/PanelContainer/MarginContainer/VBoxContainer/look_button.grab_focus())

	# pause panel
	pause_panel.after_popup.connect(func(_goal):
		paused = true
		$root/pause_panel/PanelContainer/MarginContainer/VBoxContainer/inventory_button.grab_focus())
	pause_panel.after_collapse.connect(func(goal):
		if goal == "leave_game":
			get_tree().change_scene_to_file("res://gd/screens/main_menu_screen/MainMenuScreen.tscn")
		else:
			paused = false)

	# inventory panel
	inventory_panel.after_popup.connect(func(_goal):
		$root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.grab_focus()
		$root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.selected = 0)
	inventory_panel.after_collapse.connect(func(_goal):
		ClearChildren.of($root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer)
		$root/pause_panel/PanelContainer/MarginContainer/VBoxContainer/inventory_button.grab_focus())
	inventory_panel.outer_click.connect(func():
		if inventory_item_panel.is_collapsed:
			inventory_panel.collapse())

	# inventory panel > filter button
	$root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.item_selected.connect(func(index):
		filter_inventory(index))

	# inventory panel > item panel
	inventory_item_panel.after_popup.connect(func(_goal):
		$root/inventory_item_panel/PanelContainer/MarginContainer/VBoxContainer/use_button.grab_focus())
	inventory_item_panel.after_collapse.connect(func(_goal):
		inventory_item_panel___selected_button.grab_focus())
	inventory_item_panel.outer_click.connect(func():
		if bottom_message_box_over_ui.is_open:
			return
		inventory_item_panel.collapse())

	# inventory panel > item > look button
	$root/inventory_item_panel/PanelContainer/MarginContainer/VBoxContainer/look_button.pressed.connect(func():
		get_viewport().gui_release_focus()
		bottom_message_box_over_ui.popup()
		inventory_item_panel___description_index = 0
		inventory_item_panel___show_description())

	# leave game panel
	leave_game_panel.after_popup.connect(func(_goal):
		$root/leave_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/no_button.grab_focus())
	leave_game_panel.after_collapse.connect(func(goal):
		if goal == "leave_game":
			pause_panel.collapse("leave_game")
		else:
			$root/pause_panel/PanelContainer/MarginContainer/VBoxContainer/leave_game_button.grab_focus())
	leave_game_panel.outer_click.connect(func():
		leave_game_panel.collapse())

	# leave game > yes button
	$root/leave_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/yes_button.pressed.connect(func():
		leave_game_panel.collapse("leave_game"))
	# leave game > no button
	$root/leave_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/no_button.pressed.connect(func():
		leave_game_panel.collapse())

	# pause > inventory button
	$root/pause_panel/PanelContainer/MarginContainer/VBoxContainer/inventory_button.pressed.connect(func():
		open_inventory())

	# pause > leave game button
	$root/pause_panel/PanelContainer/MarginContainer/VBoxContainer/leave_game_button.pressed.connect(func():
		leave_game_panel.popup())

	$root/pause_panel.outer_click.connect(func():
		if no_panel_other_than_pause_is_open():
			pause_panel.collapse())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# return in pause-related panels
	if paused && Input.is_action_just_released("ui_cancel"):
		if bottom_message_box.is_open:
			pass
		elif bottom_message_box_over_ui.is_open:
			pass
		else:
			var closed_one = false
			for p in pause_related_panels:
				if p.is_open:
					p.collapse()
					closed_one = true
					break
			if not closed_one:
				pause_panel.popup()
	# message boxes
	elif paused && (bottom_message_box.is_open || bottom_message_box_over_ui.is_open) && Input.is_action_just_pressed("done_reading_message"):
		if bottom_message_box.is_open && !bottom_message_box.is_typing && bottom_message_box.is_read:
			# stub
			pass
		elif bottom_message_box_over_ui.is_open && !bottom_message_box_over_ui.is_typing && bottom_message_box_over_ui.is_read:
			bottom_message_box_over_ui.collapse("inventory_look_button")
	# open/close pause
	elif not in_battle && Input.is_action_just_released("pause"):
		if paused && no_panel_other_than_pause_is_open():
			pause_panel.collapse()
		elif not paused:
			pause_panel.popup()

func no_panel_other_than_pause_is_open() -> bool:
	return pause_related_panels_but_no_root_panel.filter(func(p): return p.is_open).size() == 0

func open_inventory():
	var ct = $root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
	for item in game_state.inventory_items:
		ct.add_child(create_inventory_item_button(item))
	# focus change
	$root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.focus_neighbor_top = $root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.get_path()
	var last_button = LastChild.of(ct)
	if last_button != null:
		$root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.focus_neighbor_top = last_button.get_path()
		last_button.focus_neighbor_bottom = $root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.get_path()
	inventory_panel.popup()

func filter_inventory(index: int):
	var ct = $root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
	ClearChildren.of(ct)
	if index == 0:
		for item in game_state.inventory_items:
			ct.add_child(create_inventory_item_button(item))
	else:
		var category = inventory_category_from_index(index)
		for item in game_state.inventory_items:
			if item.category == category:
				ct.add_child(create_inventory_item_button(item))
	# focus change
	$root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.focus_neighbor_top = $root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.get_path()
	var last_button = LastChild.of(ct)
	if last_button != null:
		$root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.focus_neighbor_top = last_button.get_path()
		last_button.focus_neighbor_bottom = $root/inventory_panel/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/inventory_filter_button.get_path()

func create_inventory_item_button(item: InventoryItem):
	var btn = Button.new()
	btn.text = item.name + " × " + str(item.quantity)
	btn.alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
	btn.pressed.connect(func():
		inventory_item_panel___selected_item = item
		inventory_item_panel___selected_button = btn
		inventory_item_panel.popup())
	return btn

func inventory_category_from_index(index: int) -> InventoryItem.Category:
	return (
		InventoryItem.Category.CONSUMABLE
		if index == 1 else
		InventoryItem.Category.WEAPON
		if index == 2 else
		InventoryItem.Category.ARMOR
		if index == 3 else
		InventoryItem.Category.OTHER
	)

func inventory_item_panel___show_description():
	if inventory_item_panel___description_index == inventory_item_panel___selected_item.description.size():
		return
	var msg = inventory_item_panel___selected_item.description[inventory_item_panel___description_index]
	inventory_item_panel___description_index += 1
	bottom_message_box_over_ui.type_message(msg, inventory_item_panel___show_description)
