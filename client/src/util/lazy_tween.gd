class_name LazyTween

signal finished

func is_running() -> bool:
    return self._tween != null and self._tween.is_running()

func tween_property(property: NodePath, final_val: Variant, duration: float) -> PropertyTweener:
    if self._tween != null:
        self._tween.stop()
    self._tween = self._obj.get_tree().create_tween()
    self._tween.finished.connect(func(): self.finished.emit())
    return self._tween.tween_property(self._obj, property, final_val, duration)

func stop() -> void:
    if self._tween != null:
        self._tween.stop()
        self._tween = null

func kill() -> void:
    if self._tween != null:
        self._tween.kill()
        self._tween = null

var _tween: Tween = null
var _obj: Object

func _init(obj: Object):
    self._obj = obj
