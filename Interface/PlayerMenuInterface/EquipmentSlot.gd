@tool
extends MenuItemBase
class_name EquipmentSlot

var filter: Callable = func(_x): return true

@onready var texture_rect: ReactiveTextureField = find_child("EquipmentTexture")
@onready var border: PanelContainer = find_child("SlotBorder")

@export var frame_size: Vector2i = Vector2i.ZERO:
	set(value):
		frame_size = value
		custom_minimum_size = value

		if not is_inside_tree():
			await ready
		#texture_rect.custom_minimum_size = value
		if value == Vector2i.ZERO:
			size_flags_horizontal = Control.SIZE_EXPAND_FILL
			size_flags_vertical = Control.SIZE_EXPAND_FILL
			texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		else:
			size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			size_flags_vertical = Control.SIZE_SHRINK_CENTER
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

var item: Equipment = null:
	set(value):
		item = value
		if not is_inside_tree():
			await ready
		watch_reactive_fields(value, self)

#var texture: Texture2D:
	#set(value):
		#texture = value
		#texture_rect.texture = value

func _ready() -> void:
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		item = Equipment.generate_random_equipment()
	super()
