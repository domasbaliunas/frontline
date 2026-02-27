extends Area2D


@export var hp := 10
@onready var hp_label = $"../CanvasLayer/HP"

func _ready():
	body_entered.connect(_on_body_entered)
	update_ui()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		hp -= 1
		body.queue_free()
		update_ui()

		if hp <= 0:
			print("GAME OVER")


func update_ui():
	hp_label.text = str(hp) + " HP"
