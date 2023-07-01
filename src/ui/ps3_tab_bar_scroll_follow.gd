# A helper for making a scroll container in a tab bar
# follow the selected tab button.
class_name PS3TabBarScrollFollow

static func apply(tab_bar: PS3TabBar, container: ScrollContainer) -> void:
    tab_bar.tab_changed.connect(func(_tab):
        var tab_bar_start_x = tab_bar.global_position.x
        var tab_bar_end_x = tab_bar_start_x + tab_bar.size.x
        var btn := tab_bar.current_tab_button
        var btn_x := btn.global_position.x
        if (btn_x + btn.size.x) < tab_bar_start_x or btn_x > tab_bar_end_x:
            var btn_rel_x := btn.global_position.x - container.global_position.x
            container.scroll_horizontal = int(btn_rel_x))
