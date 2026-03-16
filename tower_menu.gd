extends CanvasLayer

var selected_tower = null
@onready var panel = $Panel
@onready var label = $Panel/VBoxContainer/Label

func _ready():
	add_to_group("tower_menu")
	hide()

func open_menu(tower):
	selected_tower = tower
	label.text = "Tower: %s\nDamage: %s\nRange: %s" % [tower.name, tower.base_damage, tower.range_value]
	panel.global_position = tower.global_position + Vector2(40, -40)
	show()

func close_menu():
	selected_tower = null
	hide()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_tower and not panel.get_global_rect().has_point(event.position):
			close_menu()
