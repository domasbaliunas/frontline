extends CharacterBody2D
class_name Enemy

@export var speed: float = 75
@export var max_health: float = 100
@export var coin_reward: int = 10

var health: float
var path_follow: PathFollow2D

# Max and min scale decides the scaling amount when damage is taken
# To damage mobs use take_damage()

func _ready() -> void:
	health = max_health
	path_follow = get_parent() as PathFollow2D
	add_to_group("mobs")

func _process(delta: float) -> void:
	move_along_path(delta)
	update_sprite_scale()

func move_along_path(delta: float):
	path_follow.progress += speed * delta
	if path_follow.progress_ratio >= 1.0:
		queue_free()

var min_scale = 0.5
var max_scale = 1.0

func update_sprite_scale():
	var health_ratio = clamp(health / max_health, 0.0, 1.0)
	var current_scale = min_scale + (health_ratio * (max_scale - min_scale))
	scale = Vector2(current_scale, current_scale)

func take_damage(amount: float) -> void:
	health -= amount
	print("Mob health:", health)

	if health <= 0:
		die()
		
func die() -> void:
	print("Mob died!")
	Currency.add_coins(coin_reward)
	queue_free()
	
	# Test senario (Press space to damage)
func _input(event):
	if event.is_action_pressed("ui_accept"):  
		take_damage(25)
