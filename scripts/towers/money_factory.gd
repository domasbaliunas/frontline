extends "res://scripts/towers/tower.gd"

@export var money_per_tick: int = 10  # Kiek bulbų duoda
@export var tick_speed: float = 10   # Kas kiek sekundžių

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var timer = $GenerationTimer
	
	$GenerationTimer.wait_time = tick_speed
	$GenerationTimer.one_shot = false 
	$GenerationTimer.start()
	$GenerationTimer.timeout.connect(_on_timer_timeout)

func _can_generate_money() -> bool:
	if get_tree().paused:
		return false

	var game_maps = get_tree().get_nodes_in_group("game_map")
	if game_maps.is_empty():
		return false

	var game_map = game_maps[0]
	if game_map != null and game_map.has_method("is_money_factory_generation_allowed"):
		return game_map.is_money_factory_generation_allowed()

	return false

func _on_timer_timeout():
	if not _can_generate_money():
		return

	if Currency:
		Currency.add_coins(money_per_tick)
		print("Pridėta: ", money_per_tick)
	else:
		print("ERROR: Currency autoload nerastas!")

func update_speed(new_speed: float):
	tick_speed = new_speed
	$GenerationTimer.wait_time = tick_speed
	$GenerationTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
