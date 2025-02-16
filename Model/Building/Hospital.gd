extends Building
class_name Hospital

func _init() -> void:
	super()
	building_name = "Hospital"
	building_description = "Heal your adventurers. No gangrene, or your money back!"
	interface = HospitalInterface
