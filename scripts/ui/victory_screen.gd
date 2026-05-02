extends Control

@onready var particles_left = $CPUParticlesLeft
@onready var particles_right = $CPUParticlesRight

func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP


func show_victory() -> void:
	get_tree().call_group("projectiles", "queue_free")
	
	var map = get_parent().get_parent()
	
	var shop = map.get_node("ShopCanvas")
	if shop: shop.hide()
	
	map.get_node("HBoxContainer").hide()
	map.get_node("HBoxContainer2").hide()
	map.get_node("HBoxContainer3").hide()
	map.get_node("HBoxContainer4").hide()
	map.get_node("WaveStartButton").hide()
	map.get_node("AutoWaveStartButton").hide()
	map.get_node("SpeedButton").hide()
	
	var main_ui = map.get_node("CanvasLayer")
	if main_ui: main_ui.hide()
	
	visible = true
	particles_left.emitting = true
	particles_right.emitting = true
	process_mode = Node.PROCESS_MODE_ALWAYS 
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
