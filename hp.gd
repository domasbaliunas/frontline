extends Label

var hp = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_text()

func update_text():
	text = str(hp) + "❤"
