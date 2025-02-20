@tool
extends PanelContainer
class_name UnitPortrait

@onready var texture_rect: ReactiveTextureField = find_child("PortraitTexture")

@export var frame_size: Vector2i = Vector2i.ZERO:
	set(value):
		frame_size = value
		custom_minimum_size = value
		if not is_inside_tree():
			await ready
		if value == Vector2i.ZERO:
			size_flags_horizontal = Control.SIZE_EXPAND_FILL
			size_flags_vertical = Control.SIZE_EXPAND_FILL
			texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
			#texture.custom_minimum_size = Vector2.ZERO
		else:
			size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			size_flags_vertical = Control.SIZE_SHRINK_CENTER
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			#texture.custom_minimum_size = value

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		var unit = Adventurer.generate_random_newbie()
		texture_rect.linked_model = unit
	#super()
