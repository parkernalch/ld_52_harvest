extends Panel

onready var menu = $MarginContainer/MenuPrompt
onready var help = $MarginContainer/HelpPrompt
onready var title = $MarginContainer/TitleScreen

var game_scene = preload("res://world.tscn")

var current_view = "menu"

func _ready():
	pass
	
func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_H:
		if current_view == "menu":
			to_help()
		elif current_view == "help":
			to_menu()
	elif event.pressed and event.scancode == KEY_SPACE:
		if current_view == "menu":
			to_title()
		elif current_view == "help":
			to_menu()
	elif event.pressed:
		if current_view == "help":
			to_menu()
	pass
	
func to_menu():
	print("going to help")
	menu.set_modulate(Color.white)
	help.set_modulate(Color.transparent)
	title.set_modulate(Color.transparent)
	current_view = "menu"
	
func to_help():
	print("going to help")
	menu.set_modulate(Color.transparent)
	help.set_modulate(Color.white)
	title.set_modulate(Color.transparent)
	current_view = "help"
	
func to_title():
	print("going to title")
	menu.set_modulate(Color.transparent)
	help.set_modulate(Color.transparent)
	title.set_modulate(Color.white)
	current_view = "title"
	yield(get_tree().create_timer(2.0), "timeout")
	to_game()
	
func to_game():
	print("going to game")
	get_tree().change_scene_to(game_scene)
