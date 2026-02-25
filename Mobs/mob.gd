extends CharacterBody2D


@export var speed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_parent().set_progress(get_parent().get_progress() + speed * delta)
	if (get_parent().get_progress_ratio() == 1):
		queue_free()
