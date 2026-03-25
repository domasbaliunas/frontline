extends CanvasLayer

var selected_tower_type = ""
var price = 0
@onready var shop_button = $Button
var is_open = false
var closed_pos = Vector2(1135, 240)
var open_pos = Vector2(1055, 240)

func _ready():
	shop_button.position = closed_pos
	shop_button.text = "<"

func _on_button_pressed():
	if is_open:
		shop_button.position = closed_pos
		shop_button.text = "<"
		is_open = false
	else:
		shop_button.position = open_pos
		shop_button.text = ">"
		is_open = true


func _on_tower_b_pressed():
	if Currency.coins >= 10: 
		selected_tower_type = "Tower"
		price = 10
		print("Tower Selected")
		
	else:
		print("Ūbagas")
