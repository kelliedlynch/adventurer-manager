@tool
extends ReactiveField
class_name ReactiveMultiField
# A field that displays the contents of an array or dictionary

@onready var layout_container: Container = find_child("LayoutContainer")
@onready var label_container: HBoxContainer = find_child("LabelContainer")
@onready var values_container: Container = find_child("ValuesContainer")
@onready var icon_rect: TextureRect = find_child("Icon")

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
		
var field_values: Array = []

func _init() -> void:
	_internal_vars_list.append("/label_position")
	_internal_vars_list.append("/list_layout")
	if get("/label_position") == null:
		set("/label_position", LabelPosition.LEFT)
	if get("/list_layout") == null:
		set("/list_layout", ContentLayout.HORIZONTAL)

func _ready() -> void:
	layout_changed.connect(_on_layout_changed)
	super()
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		icon = load("res://Graphics/Icons/White/warning.png")
		field_values = ["lorem", "ipsum", "dolor", "sit", "amet"]
		for child in values_container.get_children():
			child.queue_free()
		for val in field_values:
			var label = Label.new()
			label.text = val
			values_container.add_child(label)
			
			
func _on_layout_changed(prop_name, value_name) -> void:
	#print(prop_name, " ", value)
	if prop_name == "/label_position":
		#var prop = get(prop_name)
		var vertical = true
		if value_name == "LEFT" or value_name == "RIGHT":
			vertical = false
		var new_root: BoxContainer
		if vertical and layout_container is HBoxContainer:
			new_root = VBoxContainer.new()
		elif !vertical and layout_container is VBoxContainer:
			new_root = HBoxContainer.new()
		if new_root != null:
			if value_name == "LEFT" or value_name == "TOP":
				label_container.reparent(new_root)
				values_container.reparent(new_root)
			else:
				values_container.reparent(new_root)
				label_container.reparent(new_root)
			layout_container.queue_free()
			layout_container = new_root
			add_child(layout_container)
			layout_container.name = "LayoutContainer"
			if Engine.is_editor_hint():
				layout_container.owner = self
		notify_property_list_changed()

	if prop_name == "/list_layout":
		var new_container: Container
		if value_name == "HORIZONTAL" and not values_container is HBoxContainer:
			new_container = HBoxContainer.new()
		elif value_name == "VERTICAL" and not values_container is VBoxContainer:
			new_container = VBoxContainer.new()
		elif value_name == "GRID" and not values_container is GridContainer:
			new_container = GridContainer.new()
		if new_container != null:
			for child in values_container.get_children():
				child.reparent(new_container)
			values_container.queue_free()
			new_container.name = "Values"
			layout_container.add_child(new_container)
			values_container = new_container
			if Engine.is_editor_hint():
				values_container.owner = self
		notify_property_list_changed()

func watch_object(obj: Object):
	_linked_model = obj
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
		var v = _linked_model.get(get("/linked_property"))
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
			
func _property_list_filter(accum, val):
	if _excluded_properties.has(val.name): return accum
	if val.type & (TYPE_DICTIONARY | TYPE_ARRAY):
		return accum + val.name + ","
	return accum

func _set(property, value):
	if property == "/list_layout" or property == "/label_position":
		layout_changed.emit(property, value)
	super(property, value)
	#if property == "/list_layout":
		#_internal_vars[property] = value
		#return true
	#if property == "/label_position":
		#_internal_vars[property] = value
		#return true
	#return false
	
func _get_property_list() -> Array:
	var props = []
	var custom_classes = ProjectSettings.get_global_class_list()
	props.append_array([{
		name = "/list_layout",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = ContentLayout.keys().reduce(func(accum, val): return accum + val + ",", "").left(-1)
	},
	{
		name = "/label_position",
		type = TYPE_STRING_NAME,
		hint = PROPERTY_HINT_ENUM,
		hint_string = LabelPosition.keys().reduce(func(accum, val): return accum + val + ",", "").left(-1)
	}])
	return props
		
enum ContentLayout {
	HORIZONTAL,
	VERTICAL,
	GRID
}
enum LabelPosition {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
}
