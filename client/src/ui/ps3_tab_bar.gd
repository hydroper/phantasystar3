# Horizontal tab bar.
class_name PS3TabBar
extends Control

signal tab_changed(tab: int)

var current_tab: int:
    get:
        return self._current_tab
    set(value):
        value = clampi(value, 0, self._tab_count - 1)
        if self._current_tab == value:
            return
        self._current_tab = value
        self.tab_changed.emit(value)

var tab_count: int:
    get:
        return self._tab_count

# Reflects the present tab buttons.
func reflect_buttons() -> void:
    for btn in self._reflected_btns:
        btn.pressed.disconnect(self._btn_pressed)
        btn.focus_entered.disconnect(self._btn_focused)
    self._reflected_btns.clear()
    self._reflect_buttons_recursive($content/tabs)
    self._tab_count = len(self._reflected_btns)

func _reflect_buttons_recursive(node: Node) -> void:
    if node is PS3TabBarButton:
        var btn = node as PS3TabBarButton
        btn.pressed.connect(self._btn_pressed)
        btn.focus_entered.connect(self._btn_focused)
        self._reflected_btns.append(btn)
        return
    for node2 in node.get_children():
        self._reflect_buttons_recursive(node2)

var _reflected_btns: Array[BaseButton] = []
var _current_tab: int = 0
var _tab_count: int = 0

func _ready() -> void:
    self.reflect_buttons()
    if len(self._reflected_btns) != 0:
        self._reflected_btns[self.current_tab].tab_selected = true
    self.tab_changed.connect(func(tab):
        for btn in self._reflected_btns:
            btn.tab_selected = false
        self._reflected_btns[tab].tab_selected = true)
    $content/prev_btn.pressed.connect(func():
        self.current_tab = maxi(0, self.current_tab - 1))
    $content/next_btn.pressed.connect(func():
        self.current_tab = mini(self.current_tab + 1, self._tab_count - 1))

func _btn_pressed() -> void:
    for i in range(0, len(self._reflected_btns)):
        if self._reflected_btns[i].button_pressed:
            self.current_tab = i
            self.tab_changed.emit(i)
            break

func _btn_focused() -> void:
    for i in range(0, len(self._reflected_btns)):
        if self._reflected_btns[i].has_focus():
            self.current_tab = i
            self.tab_changed.emit(i)
            break
