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
		if !get_tree().paused:
			pause()
		else:
			resume()

func _on_resumebutton_pressed() -> void:
	resume()

func _on_restartbutton_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_quitbutton_pressed() -> void:
	get_tree().quit()
