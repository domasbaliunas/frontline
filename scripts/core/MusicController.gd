extends AudioStreamPlayer  

var music_volume: float = 0.5
var muted: bool = false

func _ready():
	pass

func apply_settings():
	if muted:
		self.volume_db = -80
	else:
		self.volume_db = linear_to_db(music_volume)
	
func toggle_mute(is_muted: bool):
	muted = is_muted
	apply_settings()

func set_volume(value: float):
	music_volume = value
	apply_settings()
