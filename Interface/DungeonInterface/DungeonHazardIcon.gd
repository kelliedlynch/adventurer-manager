@tool
extends Interface
class_name DungeonHazardIcon

var hazard: Hazard
var dungeon: Dungeon

@export var icon_size: Vector2:
	set(value):
		icon_size = value
		icon_texture.custom_minimum_size = value

@onready var icon_background: PanelContainer = find_child("IconBackground")
@onready var icon_texture: TextureRect = find_child("IconTexture")

func _ready():
	if get_tree().edited_scene_root == self:
		hazard = Hazard.new()
	icon_texture.texture = hazard.icon
	mouse_entered.connect(_on_mouse_entered)
	
func _on_mouse_entered():
	print("mouse entered")
	
func _make_custom_tooltip(_a) -> Object:
	print("making tooltip")
	var tt = load("res://Interface/GlobalInterface/Tooltip/DungeonHazardTooltip.tscn").instantiate()
	tt.hazard = hazard
	return tt

func _process(delta: float) -> void:
	#TODO: Would prefer to not be setting this every frame, but I don't know how to compare to the existing
	#		stylebox to see if it needs to be set
	if not Engine.is_editor_hint():
		var box: String
		match hazard.get_mitigated_state(dungeon):
			Hazard.MitigatedState.PARTIAL:
				box = "hazard_partial_active"
			Hazard.MitigatedState.INACTIVE:
				box = "hazard_inactive"
			_:
				box = "panel"
		remove_theme_stylebox_override("panel")
		add_theme_stylebox_override("panel", get_theme_stylebox(box, theme_type_variation))
		icon_background.add_theme_stylebox_override("panel", get_theme_stylebox(box, icon_background.theme_type_variation))

static func instantiate(haz: Hazard, dun: Dungeon) -> DungeonHazardIcon:
	var menu = load("res://Interface/DungeonInterface/DungeonHazardIcon.tscn").instantiate()
	menu.hazard = haz
	menu.dungeon = dun
	return menu
