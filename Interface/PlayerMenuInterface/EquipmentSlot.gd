@tool
extends MenuItemBase
class_name EquipmentSlot

var filter: Callable = func(x): return true

@onready var texture_rect: TextureRect = find_child("EquipmentTexture")
@onready var background: PanelContainer = find_child("SlotBackground")

var item: Equipment:
	set(value):
		item = value
		if value:
			texture = value.texture

var texture: Texture2D:
	set(value):
		texture = value
		texture_rect.texture = value

func _ready() -> void:
	texture = texture
	super()

func _on_mouse_entered():
	pass
	
func _on_mouse_exited():
	pass

func _on_gui_input(event: InputEvent):
	super(event)
