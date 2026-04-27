extends CanvasLayer

@onready var completedLabel: Label = $CompletedLabel

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func show_message():
	visible = true
	get_tree().paused = true
	await get_tree().create_timer(2.0, true, false, true).timeout
	visible = false
	get_tree().paused = false
