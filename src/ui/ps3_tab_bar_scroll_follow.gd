# A helper for making a scroll container in a tab bar
# follow the selected tab button.
class_name PS3TabBarScrollFollow

static func apply(tab_bar: PS3TabBar, container: ScrollContainer) -> void:
    tab_bar.tab_changed.connect(func(_tab):
        var btn = tab_bar.current_tab_button
        container.scroll_horizontal = int(btn.global_position.x - container.global_position.x))
