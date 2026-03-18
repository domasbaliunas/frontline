
extends "res://tower.gd"

func _ready():
	super._ready()
	
	base_damage = 100
	attack_speed = 0.0667
	
	set_range(99999)
	
	attack_timer.wait_time = 1.0 / attack_speed
