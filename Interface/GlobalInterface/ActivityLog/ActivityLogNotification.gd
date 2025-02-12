extends PanelContainer
class_name ActivityLogNotification

var fade_tween: Tween

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	fade_tween = Tween.new()
	fade_tween.tween_interval(1)
	fade_tween.tween_callback(_fade_out)
	
func _on_mouse_entered():
	if fade_tween:
		fade_tween.kill()
		create_tween().tween_property(self, "modulate:a", 1, .1)

func _on_mouse_exited():
	_fade_out()

func _fade_out():
	fade_tween = Tween.new()
	fade_tween.tween_property(self, "modulate:a", 0, .6)
	fade_tween.tween_callback(queue_free)
