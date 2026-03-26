extends CanvasLayer

var selected_tower_type := ""
var price := 0

@onready var shop_button: Button = $Button
@onready var panel: PanelContainer = $PanelContainer

var is_open := false
var tween: Tween

var closed_x: float
var open_x: float


func _ready():
	await get_tree().process_frame

	var screen_size = get_viewport().get_visible_rect().size
	var panel_size = panel.size
	var button_size = shop_button.size

	open_x = screen_size.x - panel_size.x
	closed_x = screen_size.x

	panel.position.y = (screen_size.y - panel_size.y) / 2

	panel.position.x = closed_x

	shop_button.position.x = closed_x - button_size.x
	shop_button.position.y = panel.position.y + panel_size.y / 2 - button_size.y / 2

	shop_button.text = "<"


func _on_button_pressed():
	if tween:
		tween.kill()

	var button_size = shop_button.size

	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)

	is_open = !is_open

	if is_open:
		tween.tween_property(panel, "position:x", open_x, 0.25)

		tween.tween_property(
			shop_button,
			"position:x",
			open_x - button_size.x,
			0.25
		)

		shop_button.text = ">"
	else:
		tween.tween_property(panel, "position:x", closed_x, 0.25)

		tween.tween_property(
			shop_button,
			"position:x",
			closed_x - button_size.x,
			0.25
		)

		shop_button.text = "<"


func _on_tower_b_pressed():
	if Currency.coins >= 10:
		selected_tower_type = "Tower"
		price = 10
		print("Tower Selected")
	else:
		print("Not enough money")
