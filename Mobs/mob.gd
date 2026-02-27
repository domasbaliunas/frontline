extends CharacterBody2D
class_name Mob

@export var speed: float = 75
@export var max_health: float = 100

var health: float
var mob = preload("res://Mobs/mob.tscn")

# Max and min scale decides the scaling amount when damage is taken
# To damage mobs use take_damage()

func _ready() -> void:
	health = max_health
	add_to_group("mobs")

func _process(delta: float) -> void:

	get_parent().set_progress(get_parent().get_progress() + speed * delta)
	
	if get_parent().get_progress_ratio() >= 1:
		queue_free()
	
	var health_ratio = clamp(health / max_health, 0.0, 1.0)

	var min_scale = 0.5
	var max_scale = 1.0

	var current_scale = min_scale + (health_ratio * (max_scale - min_scale))
	scale = Vector2(current_scale, current_scale)

func take_damage(amount: float) -> void:
	health -= amount
	print("Mob health:", health)

	if health <= 0:
		die()
		
func die() -> void:
	print("Mob died!")
	queue_free()
	
	# Test senario (Press space to damage)
func _input(event):
	if event.is_action_pressed("ui_accept"):  
		take_damage(25)
