extends CanvasLayer

@onready var damage_flash: ColorRect = $DamageFlash
var flash_tween: Tween

func _ready():
	damage_flash.modulate.a = 0.0
	damage_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE

func play_damage_flash():
	print("FLASH PLAYED") 
	
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()

	damage_flash.modulate.a = 0.0

	flash_tween = create_tween()
	flash_tween.tween_property(damage_flash, "modulate:a", 0.5, 0.05)
	flash_tween.tween_interval(0.1) 
	flash_tween.tween_property(damage_flash, "modulate:a", 0.0, 0.3)
