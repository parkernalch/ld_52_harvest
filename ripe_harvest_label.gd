extends Label


func _ready():
	EventBus.connect("ripe_count_changed", self, "_update_count")
	
func _update_count(new_count):
	text = str(new_count)
