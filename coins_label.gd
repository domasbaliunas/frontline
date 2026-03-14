extends Label

var displayed_amount := 0
@onready var coin = $"../Coin"  # TextureRect node

func _ready():
	displayed_amount = Currency.coins
	update_text(displayed_amount)
	Currency.coins_changed.connect(animate_to)

func animate_to(new_amount):
	var animation_duration := 0.25  # tiek laiko truks viskas
	var tween = create_tween()

	# Visi tweenai parallel, prasideda tuo pačiu metu
	tween.parallel().tween_property(coin, "scale", Vector2(1.3, 1.3), animation_duration / 2)
	tween.parallel().tween_property(coin, "scale", Vector2(1, 1), animation_duration / 2).set_delay(animation_duration / 2)

	tween.parallel().tween_property(self, "scale", Vector2(1.15, 1.15), animation_duration / 2)
	tween.parallel().tween_property(self, "scale", Vector2(1, 1), animation_duration / 2).set_delay(animation_duration / 2)

	# Skaičiaus animacija vyksta tuo pačiu metu
	tween.parallel().tween_method(update_text, displayed_amount, new_amount, animation_duration)

	displayed_amount = new_amount

func update_text(amount):
	text = str(int(amount))
