extends Node2D

@export var attack_speed = 0.75
var projectile_scene: PackedScene = preload("res://Projectile.tscn")

var attack_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("towers", true)
	attack_timer = Timer.new()
	attack_timer.wait_time = 1 / attack_speed
	attack_timer.one_shot = false
	attack_timer.autostart = true
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	add_child(attack_timer)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_attack_timer_timeout():
	var target = get_target()
	if target != null:
		attack(target)

# Only look for Mob nodes in the "mobs" group
func get_target() -> Mob:
	var closest: Mob = null
	var closest_dist = INF
	for mob in get_tree().get_nodes_in_group("mobs"):
		if not mob is Mob:
			continue
		var dist = global_position.distance_to(mob.global_position)
		if dist < closest_dist:
			closest = mob
			closest_dist = dist
	return closest
	
func attack(target: Mob):
	if projectile_scene == null:
		return
	var proj = projectile_scene.instantiate()
	proj.global_position = global_position
	proj.target = target
	get_tree().current_scene.add_child(proj)
