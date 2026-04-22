extends Node

const DEFAULT_COINS: int = 10

var coins: int = DEFAULT_COINS

signal coins_changed(new_amount)

func add_coins(amount: int):
	coins += amount
	coins_changed.emit(coins)

func spend_coins(amount: int):
	if coins >= amount:
		coins -= amount
		coins_changed.emit(coins)

func reset_coins() -> void:
	coins = DEFAULT_COINS
	coins_changed.emit(coins)
