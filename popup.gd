extends MarginContainer

func _ready():
	set_modulate(Color.transparent)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			toggle_visibility()
		if modulate == Color.white and event.is_action_pressed("restart"):
			EventBus.emit_signal("restart_game")
			modulate = Color.transparent
			
func toggle_visibility():
	if modulate == Color.white:
		set_modulate(Color.transparent)
	else:
		set_modulate(Color.white)
