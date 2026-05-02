extends CanvasLayer

@onready var flash = $Flash
@onready var panel = $Panel

func _ready():
	visible = false
	Game_Over_Signal.game_over.connect(_on_game_over)

func _on_game_over():
	get_tree().call_group("mobs", "set_process", false)
	get_tree().call_group("projectiles", "queue_free")
	get_tree().set_group("towers", "is_game_over", true)
	
	var main_ui = get_tree().current_scene.get_node("CanvasLayer")
	if main_ui:
		main_ui.hide()
	
	get_parent().get_node("HBoxContainer").hide()
	get_parent().get_node("HBoxContainer2").hide()
	get_parent().get_node("HBoxContainer3").hide()
	get_parent().get_node("HBoxContainer4").hide()
	get_parent().get_node("WaveStartButton").hide()
	get_parent().get_node("AutoWaveStartButton").hide()
	get_parent().get_node("SpeedButton").hide()
	
	
	var shop = get_parent().get_node("ShopCanvas") 
	if shop:
		shop.hide()
	
	var pause_button = get_tree().root.find_child("PauseMenuButton", true, false)
	if pause_button:
		pause_button.hide()
	
	flash.visible = true
	var tween = create_tween()
	tween.tween_property(flash, "color:a", 0.5, 0.1)
	tween.tween_property(flash, "color:a", 0.0, 0.2).set_delay(0.1)
	
	visible = true
	


func _on_restart_btn_pressed() -> void:
	get_tree().reload_current_scene()
	Currency.reset_coins()


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
