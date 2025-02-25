extends PanelContainer
class_name ActivityLogNotification

var display_tween: Tween
var fade_tween: Tween
var message: ActivityLogTextLabel
var duration: float = 2
var delay: float

func _init(msg: ActivityLogMessage, timeout_delay: float = 0):
	message = ActivityLogTextLabel.new(msg)
	delay = timeout_delay

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	message.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(message)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	display_tween = create_tween()
	if delay > 0:
		display_tween.tween_interval(delay)
	display_tween.tween_interval(duration)
	display_tween.tween_callback(_fade_out)
	
func _on_mouse_entered():
	if !display_tween and !fade_tween: return
	if display_tween:
		display_tween.stop()
	if fade_tween:
		fade_tween.kill()
	create_tween().tween_property(self, "modulate:a", 1, .1)

func _on_mouse_exited():
	if display_tween.is_valid():
		display_tween.play()
	else:
		_fade_out()

func _fade_out():
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0, .6)
	fade_tween.tween_callback(queue_free)

func cancel():
	if fade_tween:
		fade_tween.kill()
	if display_tween:
		display_tween.kill()
	queue_free()
