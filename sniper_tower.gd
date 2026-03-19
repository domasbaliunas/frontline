
extends "res://tower.gd"

const SNIPER_BASE_DAMAGE := 100.0
const SNIPER_ATTACK_SPEED := 0.1
const SNIPER_RANGE := 99999.0

func _ready() -> void:
	base_damage = SNIPER_BASE_DAMAGE
	attack_speed = SNIPER_ATTACK_SPEED
	super._ready()
	set_range(SNIPER_RANGE)
