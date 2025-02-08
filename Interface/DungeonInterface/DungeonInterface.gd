extends Menu
class_name DungeonInterface

var model: Dungeon
@onready var idle_units_list: UnitList = $HBoxContainer/IdleUnits
@onready var dungeon_panel: VBoxContainer = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer
@onready var dungeon_units_list: UnitList = $HBoxContainer/VBoxContainer/DungeonParty
@onready var send_button: Button = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DungeonActions/SendParty
@onready var party_status_label: Label = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DungeonActions/PartyStatus
@onready var remaining_time: LabeledField = $HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/DungeonActions/RemainingTime

#var staged_party: Array[Adventurer] = []

func _ready() -> void:
	if get_tree().current_scene == self or Engine.is_editor_hint():
		model = Dungeon.new()
	var idle = Player.roster.filter(func (x): return x.status == Adventurer.STATUS_IDLE)
	for adv in idle:
		idle_units_list.add_unit(adv)
	if not is_inside_tree():
		await ready
	#for item in idle_units_list.list_items.get_children():
		#item.item_clicked.connect(_add_to_party.bind(item.unit))
	idle_units_list.item_clicked.connect(_add_to_party)
	dungeon_units_list.item_clicked.connect(_remove_from_party)
	_watch_labeled_fields(model, dungeon_panel)
	send_button.pressed.connect(_on_press_send_button)
	model.property_changed.connect(_on_dungeon_property_changed)
	super._ready()
	
func _on_dungeon_property_changed(prop: String):
	if prop == "questing":
		if model.questing == true:
			send_button.disabled = true
			party_status_label.text = "Exploring dungeon"
			remaining_time.label = "Time left"
			remaining_time.set("/linked_property", "remaining_quest_time")
		else:
			send_button.disabled = false
			party_status_label.text = "Not ready"
			remaining_time.label = "Time"
			remaining_time.set("/linked_property", "quest_time")
	
func _on_press_send_button():
	if model.party.is_empty():
		model.party.append_array(dungeon_units_list.units)
		for unit in model.party:
			dungeon_units_list.remove_unit(unit)
		party_status_label.text = "Party Exploring"
		model.begin_quest()

func _add_to_party(unit: Adventurer):
	if dungeon_units_list.units.size() >= model.max_party_size:
		return
	idle_units_list.remove_unit(unit)
	dungeon_units_list.add_unit(unit)
	party_status_label.text = "Party: %d/%d" % [dungeon_units_list.units.size(), model.max_party_size]
	send_button.disabled = false
	
func _remove_from_party(unit: Adventurer):
	idle_units_list.add_unit(unit)
	dungeon_units_list.remove_unit(unit)
	if dungeon_units_list._units.size() == 0:
		party_status_label.text = "Not ready"
		send_button.disabled = true
	else:
		party_status_label.text = "Party: %d/%d" % [dungeon_units_list.units.size(), model.max_party_size]
		send_button.disabled = false

static func instantiate(dungeon: Dungeon) -> DungeonInterface:
	var menu = load("res://Interface/DungeonInterface/DungeonInterface.tscn").instantiate()
	menu.model = dungeon
	return menu
