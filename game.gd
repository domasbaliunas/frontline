extends Node2D

@onready var pause_menu: Control = $PauseMenuGroup/CanvasLayer/PauseMenu

func _on_texture_button_pressed() -> void:
	pause_menu.pause()
	pause_menu.visible = true
