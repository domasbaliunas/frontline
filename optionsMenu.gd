extends Control

@onready var slider = $MusicSlider
@onready var mute_btn = $MuteButton

func _ready():
	slider.value = MeniuMusic.music_volume
	slider.value = GameMusic.music_volume
	slider.editable = !MeniuMusic.muted
	slider.editable = !GameMusic.muted
	_update_mute_button_text()

func _on_music_slider_value_changed(value: float) -> void:
	MeniuMusic.set_volume(value)
	GameMusic.set_volume(value)
	print(value)

func _on_mute_button_pressed() -> void:
	MeniuMusic.toggle_mute(!MeniuMusic.muted)
	GameMusic.toggle_mute(!GameMusic.muted)
	slider.editable = !MeniuMusic.muted
	slider.editable = !GameMusic.muted
	_update_mute_button_text()

func _update_mute_button_text():
	mute_btn.text = "Unmute" if MeniuMusic.muted else "Mute"

func _on_back_button_pressed() -> void:
	if get_tree().current_scene.name == "OptionsMenu": 
		get_tree().change_scene_to_file("res://main_menu.tscn")
	else:
		self.visible = false
