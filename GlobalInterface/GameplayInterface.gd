extends VBoxContainer

func _ready() -> void:
	$MenuBar/RosterButton.pressed.connect(_on_roster_button_pressed)
	
func _on_roster_button_pressed():
	var menu = $Main.find_child("RosterMenu")
	#menu.owner = self
	if menu:
		$Main.remove_child(menu)
		menu.queue_free()
	else:
		menu = load("res://RosterInterface/Roster.tscn").instantiate()
		$Main.add_child(menu)
		menu.owner = $Main
