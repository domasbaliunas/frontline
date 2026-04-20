extends CanvasLayer

var selected_tower = null
@onready var panel = $Panel
@onready var label = $Panel/VBoxContainer/Label
@onready var sell_button = $Panel/VBoxContainer/Button
#const coef = 0.7
var just_opened: bool = false

func _ready():
	add_to_group("tower_menu")
	hide()

func open_menu(tower):
	selected_tower = tower
	label.text = "Tower: %s\nDamage: %s\nRange: %s" % [tower.name, tower.base_damage, tower.range_value]
	panel.global_position = tower.global_position + Vector2(40, -40)
	just_opened = true
	show()

func close_menu():
	if selected_tower and selected_tower.has_method("set_range_visible"):
		selected_tower.set_range_visible(false)
	selected_tower = null
	hide()
	
func _on_sell_pressed():
	if selected_tower == null:
		return
	if selected_tower.has_method("sell_tower"):
		selected_tower.sell_tower()

	selected_tower.queue_free()
	close_menu()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_tower == null:
			return
		if panel.get_global_rect().has_point(event.position):
			return
		var dist = selected_tower.global_position.distance_to(event.position)
		if dist < 24:
			return
		close_menu()
