extends Node2D

@export var money_per_tick: int = 10  # Kiek bulbų duoda
@export var tick_speed: float = 10   # Kas kiek sekundžių

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var timer = $GenerationTimer
	
	$GenerationTimer.wait_time = tick_speed
	$GenerationTimer.one_shot = false 
	$GenerationTimer.start()
	$GenerationTimer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
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
