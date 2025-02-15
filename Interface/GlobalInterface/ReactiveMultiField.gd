@tool
extends ReactiveField
class_name ReactiveMultiField
# A field that displays the contents of an array or dictionary


@onready var values_container: Container = find_child("ValuesContainer")
#@onready var icon_rect: TextureRect = find_child("Icon")

#var list_layout: ContentLayout = ContentLayout.HORIZONTAL:
	#set(value):
		#list_layout = value
		#if not is_inside_tree():
			#await ready
		#layout_changed.emit()
signal layout_changed
#
#var label_position: LabelPosition = LabelPosition.LEFT:
	#set(value):
		#label_position = value
		#if not is_inside_tree():
			#await ready
		#layout_changed.emit()
		
@export var grid_columns: int = 3:
	set(value):
		grid_columns = value
		if not is_inside_tree():
			await ready
		if values_container is GridContainer:
			values_container.columns = value
		
var field_values: Array = []

func _ready() -> void:
	grid_columns = grid_columns
	layout_changed.connect(_on_layout_changed)
	#super()
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		field_values = ["lorem", "ipsum", "dolor", "sit", "amet"]
		for child in values_container.get_children():
			child.queue_free()
		for val in field_values:
			var label = Label.new()
			label.text = val
			values_container.add_child(label)
			if Engine.is_editor_hint():
				label.owner = self
	else:
		grid_columns = grid_columns
		set("/label_position", get("/label_position"))
		set("/list_layout", get("/list_layout"))
		
			
			
func _on_layout_changed(prop_name, value_name) -> void:
	if prop_name == "/list_layout":
		var new_container: Container
		if value_name == "HORIZONTAL" and not values_container is HBoxContainer:
			new_container = HBoxContainer.new()
		elif value_name == "VERTICAL" and not values_container is VBoxContainer:
			new_container = VBoxContainer.new()
		elif value_name == "GRID" and not values_container is GridContainer:
			new_container = GridContainer.new()
			new_container.columns = grid_columns
		if new_container != null:
			for child in values_container.get_children():
				child.reparent(new_container)
			values_container.name = "fordeletion"
			values_container.queue_free()
			new_container.name = "ValuesContainer"
			add_child(new_container)
			values_container = new_container
		notify_property_list_changed()

func watch_object(obj: Object):
	linked_model = obj
	var prop = obj.get(get("/linked_property"))
	for child in values_container.get_children():
		child.queue_free()
	if prop and not prop.is_empty():
		var values_list = prop if prop is Array else prop.values()
		for value in values_list:
			_add_value_interface(value)
	if prop:
		if not obj.property_changed.is_connected(_on_property_changed):
			obj.property_changed.connect(_on_property_changed)
			
func _add_value_interface(value):
	var label = Label.new()
	label.text = value
	values_container.add_child(label)

func _on_property_changed(prop_name: String):
	if prop_name == get("/linked_property"):
		var v = linked_model.get(get("/linked_property"))
		var values_list = v if v is Array else v.values()
		var updated = []
		if values_list == field_values: return
		field_values = values_list
		for child in values_container.get_children():
			child.queue_free()
		for value in field_values:
			var label = Label.new()
			label.text = value
			values_container.add_child(label)
			pass
			
#func _property_list_filter(accum, val):
	#if val.has(val.name): return accum
	#if val.type & (TYPE_DICTIONARY | TYPE_ARRAY):
		#return accum + val.name + ","
	#return accum

func _set(property, value):
	if property == "/list_layout":
		layout_changed.emit(property, value)
	super(property, value)
	#if property == "/list_layout":
		#_internal_vars[property] = value
		#return true
	#if property == "/label_position":
		#_internal_vars[property] = value
		#return true
	#return false
func _reduce_prop_list(accum, val):
	if val.type & (TYPE_DICTIONARY | TYPE_ARRAY):
		return accum + val + ","
	return accum
	
func _get_property_list() -> Array:
	var props = []
	var custom_classes = ProjectSettings.get_global_class_list()
	props.append_array([{
		name = "/list_layout",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = ContentLayout.keys().reduce(func(accum, val): return accum + val + ",", "").left(-1)
	},
	#{
		#name = "/label_position",
		#type = TYPE_STRING_NAME,
		#hint = PROPERTY_HINT_ENUM,
		#hint_string = LabelPosition.keys().reduce(func(accum, val): return accum + val + ",", "").left(-1)
	#}
	])
	return props
		
enum ContentLayout {
	HORIZONTAL,
	VERTICAL,
	GRID
}
