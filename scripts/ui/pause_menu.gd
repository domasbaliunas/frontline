extends Control

func _ready():
	self.visible = false
	$AnimationPlayer.play("RESET")

func resume():
	self.visible = false
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	self.visible = true
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		
		var victory = get_tree().current_scene.find_child("VictoryScreen", true, false)
		var is_victory_visible = victory != null and victory.visible
		
		if is_victory_visible: return
		
		if !get_tree().paused:
			pause()
		else:
			resume()

func _on_resumebutton_pressed() -> void:
	resume()

func _on_restartbutton_pressed() -> void:
	resume()
	Currency.reset_coins()
	get_tree().reload_current_scene()

func _on_mainmenubutton_pressed() -> void:
	resume()
	if GameMusic:
		GameMusic.stop()
	if MeniuMusic:
		MeniuMusic.play()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
