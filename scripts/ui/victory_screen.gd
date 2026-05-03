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
	
	
	var nodes_to_hide = [
		"HBoxContainer", "HBoxContainer2", "HBoxContainer3", "HBoxContainer4",
		"WaveStartButton", "AutoWaveStartButton", "SpeedButton"]
	
	for node_name in nodes_to_hide:
		var node = get_parent().get_parent().get_node_or_null(node_name)
		if node:
			node.hide()
	
	
	
	var main_ui = map.get_node("CanvasLayer")
	if main_ui: main_ui.hide()
	
	var pause_button = get_tree().root.find_child("PauseMenuGroup", true, false)
	if pause_button:
		pause_button.hide()
	
	var TowerMenu = get_tree().root.find_child("TowerMenu", true, false)
	if TowerMenu:
		TowerMenu.hide()
	
	
	visible = true
	particles_left.emitting = true
	particles_right.emitting = true
	process_mode = Node.PROCESS_MODE_ALWAYS 
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	GameMusic.stop()
	MeniuMusic.play()
