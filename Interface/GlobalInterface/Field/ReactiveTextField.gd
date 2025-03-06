@tool
extends Reactive
class_name ReactiveTextField

func update_from_linked_object():
	if not linked_property: return
	if get_tree().current_scene == self or get_tree().edited_scene_root == self:
		return
	var prop_val = str(linked_object.get(linked_property)) if linked_object else ""
	if self.text != prop_val:
		self.text = prop_val
