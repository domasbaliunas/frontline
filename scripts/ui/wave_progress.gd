extends Control

@onready var progress_bar: ProgressBar = $WaveProgressBar

var initial_health_sum: float = 0.0
var unspawned_health_sum: float = 0.0
var hide_request_id: int = 0

func _ready() -> void:
	hide()
	progress_bar.min_value = 0.0
	progress_bar.max_value = 100.0
	progress_bar.value = 0.0

func start_wave(total_health: float) -> void:
	hide_request_id += 1 

	initial_health_sum = maxf(total_health, 0.0)
	unspawned_health_sum = initial_health_sum

	show()
	_set_progress(0.0)

func enemy_spawned(enemy_max_health: float) -> void:
	unspawned_health_sum = maxf(unspawned_health_sum - enemy_max_health, 0.0)

func update_wave_progress(alive_health_sum: float) -> void:
	if initial_health_sum <= 0.0:
		_set_progress(1.0)
		return

	var current_total_health := unspawned_health_sum + maxf(alive_health_sum, 0.0)
	var progress := (initial_health_sum - current_total_health) / initial_health_sum

	_set_progress(progress)

func complete_wave() -> void:
	_set_progress(1.0)

	hide_request_id += 1
	var current_id = hide_request_id

	await get_tree().create_timer(2.0).timeout

	# only hide if no new wave started
	if current_id == hide_request_id:
		hide()

func reset() -> void:
	initial_health_sum = 0.0
	unspawned_health_sum = 0.0
	_set_progress(0.0)
	hide()

func _set_progress(progress: float) -> void:
	progress = clampf(progress, 0.0, 1.0)

	var percent := progress * 100.0
	progress_bar.value = percent
