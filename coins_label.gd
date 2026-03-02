extends Label

var displayed_amount := 0

func _ready():
	displayed_amount = Currency.coins
	update_text(displayed_amount)
	Currency.coins_changed.connect(animate_to)

func animate_to(new_amount):
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.08)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.08)
	tween.parallel().tween_method(update_text, displayed_amount, new_amount, 0.25)
	displayed_amount = new_amount

func update_text(amount):
	text = "🪙 " + str(int(amount))
