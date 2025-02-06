extends Menu
class_name DungeonInterface

var model: Dungeon
@onready var idle_units_list: UnitList = $HBoxContainer/IdleUnits
@onready var dungeon_panel: VBoxContainer = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer
@onready var dungeon_units_list: UnitList = $HBoxContainer/VBoxContainer/DungeonParty
@onready var send_button: Button = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DungeonActions/SendParty
@onready var party_status_label: Label = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DungeonActions/PartyStatus

var current_party: Array[Adventurer] = []

func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		model = Dungeon.new()
	idle_units_list._units = Player.roster
	if not is_inside_tree():
		await ready
	#for item in idle_units_list.list_items.get_children():
		#item.item_clicked.connect(_add_to_party.bind(item.unit))
	idle_units_list.item_clicked.connect(_add_to_party)
	dungeon_units_list.item_clicked.connect(_remove_from_party)
	_watch_labeled_fields(model, dungeon_panel)
	send_button.pressed.connect(_on_press_send_button)
	
func _on_press_send_button():
	if current_party.is_empty():
		current_party.append_array(dungeon_units_list._units)
		for unit in current_party:
			dungeon_units_list.remove_unit(unit)
		send_button.text = "Recall Party"
		send_button.disabled = false
		party_status_label.text = "Party Exploring"
	else:
		for unit in current_party:
			idle_units_list.add_unit(unit)
		current_party.clear()
		send_button.text = "Send Party"
		send_button.disabled = true
		party_status_label.text = "Party Exploring"
	pass

func _add_to_party(unit: Adventurer):
	if dungeon_units_list._units.size() >= 4:
		return
	idle_units_list.remove_unit(unit)
	dungeon_units_list.add_unit(unit)
	if dungeon_units_list._units.size() == 4:
		party_status_label.text = "Ready"
		send_button.disabled = false
	else:
		party_status_label.text = "Not Ready"
		send_button.disabled = true
	
func _remove_from_party(unit: Adventurer):
	idle_units_list.add_unit(unit)
	dungeon_units_list.remove_unit(unit)
	if dungeon_units_list._units.size() == 4:
		party_status_label.text = "Ready"
		send_button.disabled = false
	else:
		party_status_label.text = "Not Ready"
		send_button.disabled = true

static func instantiate() -> DungeonInterface:
	return load("res://Interface/DungeonInterface/DungeonInterface.tscn").instantiate()
