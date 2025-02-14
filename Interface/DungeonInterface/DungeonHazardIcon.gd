extends Interface
class_name DungeonHazardIcon

var hazard: Hazard
var dungeon: Dungeon

@onready var icon_background: PanelContainer = find_child("IconBackground")
@onready var icon_texture: TextureRect = find_child("IconTexture")

func _ready():
	icon_texture.texture = hazard.icon

func refresh_icon():
	var box: String
	match hazard.get_mitigated_state(dungeon):
		#Hazard.MitigatedState.ACTIVE:
			#add_theme_stylebox_override("panel", get_theme_stylebox("panel", theme_type_variation))
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
