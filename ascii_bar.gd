extends Label

export var current_level: int
enum STAT {
	WATER, FUEL, SEEDS
}
export(STAT) var label_stat: int

func _ready():
	EventBus.connect("restart_game", self, "_on_restart_game")
	match label_stat:
		STAT.WATER:
			EventBus.connect("water_level_changed", self, "_on_level_changed")
		STAT.FUEL:
			EventBus.connect("fuel_level_changed", self, "_on_level_changed")
		STAT.SEEDS:
			EventBus.connect("seed_level_changed", self, "_on_level_changed")

func _on_restart_game():
	current_level = 10
	_draw()
	pass

func _draw():
	var chars = ""
	for i in range(10):
		if current_level > i:
			chars = chars + "|"
		else:
			chars = chars + " "
	
	text = "[" + chars + "]"

func _on_level_changed(new_level):
	current_level = new_level
	_draw()
