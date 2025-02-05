@tool
extends PanelContainer
class_name TownInterfaceBuilding

@onready var name_label: Label = $VBoxContainer/BuildingName
@onready var description_label: Label = $VBoxContainer/BuildingDescription
@onready var enter_button: Button = $VBoxContainer/EnterBuilding

@export var building_name: String = "Building Named":
	set(value):
		building_name = value
		if not is_inside_tree():
			await ready
		name_label.text = value
		
@export_multiline var description: String = "Description of what you can do at this building":
	set(value):
		description = value
		if not is_inside_tree():
			await ready
		description_label.text = value
