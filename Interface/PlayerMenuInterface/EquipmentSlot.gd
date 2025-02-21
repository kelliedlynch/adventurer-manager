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

func _set(property, value):
	if property == "__linked_class" and texture_rect:
		texture_rect.linked_class = value
	return super(property, value)

#func update_from_linked_object():
	#if linked_object != texture_rect.linked_object:
		#texture_rect.link_object(linked_object)

func link_object(obj: Variant, node: Node = self):
	if obj and Utility.is_derived_from(obj.get_script().get_global_name(), linked_class):
		texture_rect.link_object(obj)
	super(obj, node)
	
func unlink_object(obj: Variant, node: Node = self):
	if obj and obj is Equipment:
		texture_rect.unlink_object(obj)
	super(obj, node)

func _ready() -> void:
	texture_rect.linked_class = linked_class
	texture_rect.linked_property = "texture"
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		link_object(Equipment.generate_random_equipment())
	super()
