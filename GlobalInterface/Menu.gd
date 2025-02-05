extends Control
class_name Menu

@onready var window_size: Vector2 = get_window().size

func _ready() -> void:
	get_window().size_changed.connect(_on_window_size_changed)
	
func _on_window_size_changed() -> void:
	pass
