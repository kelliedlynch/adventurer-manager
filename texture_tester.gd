@tool
extends VBoxContainer

@export_range(0, 31) var texture: int = 0:
	set(value):
		texture = value
		var val_str = str(value).pad_zeros(3)
		for row in get_children():
			for panel in row.get_children():
				panel.texture = load("res://Graphics/LargeBorders/Panel/panel-%s.png" % val_str)
				for border in panel.get_children():
					border.texture = load("res://Graphics/LargeBorders/Border/panel-border-%s.png" % val_str)

@export_color_no_alpha var border_color: Color:
	set(value):
		border_color = value
		for row in get_children():
			for panel in row.get_children():
				for border in panel.get_children():
					border.self_modulate = value
					
@export_color_no_alpha var panel_color: Color:
	set(value):
		panel_color = value
		for row in get_children():
			for panel in row.get_children():
				panel.self_modulate = value

@export_tool_button("Make Texture") var tool_btn = _on_export_pressed

func _ready() -> void:
	#tool_btn.pressed.connect(_on_export_pressed)
	pass
	
func _on_export_pressed():
	var panel = Image.new()
	var border = Image.new()
	panel.load("res://Graphics/LargeBorders/Panel/panel-%s.png" % str(texture).pad_zeros(3))
	border.load("res://Graphics/LargeBorders/Border/panel-border-%s.png" % str(texture).pad_zeros(3))
	var p_size = panel.get_size()
	var result = Image.create_empty(p_size.x, p_size.y, panel.has_mipmaps(), panel.get_format())
	for x in p_size.x:
		for y in p_size.y:
			var b_pix = border.get_pixel(x, y)
			if b_pix.a != 0:
				result.set_pixel(x, y, border_color)
			else:
				var p_pix = panel.get_pixel(x, y)
				if p_pix.a != 0:
					result.set_pixel(x, y, panel_color)
	var path = "res://Graphics/LargeBorders/Exported/b_%s_p_%s.png" % [border_color.to_html(), panel_color.to_html()]
	result.save_png(path)
