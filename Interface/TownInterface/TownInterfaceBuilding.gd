extends PanelContainer
class_name TownInterfaceBuilding

@onready var name_label: ReactiveField = $VBoxContainer/BuildingName
@onready var description_label: ReactiveField = $VBoxContainer/MarginContainer/BuildingDescription
@onready var enter_button: Button = $VBoxContainer/EnterBuilding

static func instantiate() -> TownInterfaceBuilding:
	return load("res://Interface/TownInterface/TownInterfaceBuilding.tscn").instantiate()
