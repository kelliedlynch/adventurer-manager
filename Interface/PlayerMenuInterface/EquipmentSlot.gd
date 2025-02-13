@tool
extends MenuItemBase
class_name EquipmentSlot

var filter: Callable = func(x): return true

@onready var texture_rect: TextureRect = find_child("EquipmentTexture")
@onready var background: PanelContainer = find_child("SlotBackground")

var texture: Texture2D:
	set(value):
		texture = value
		texture_rect.texture = value

func _ready() -> void:
	super()
