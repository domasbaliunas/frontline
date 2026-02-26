extends Node

var coins: int = 0

signal coins_changed(new_amount)

func add_coins(amount: int):
	coins += amount
	coins_changed.emit(coins)

func spend_coins(amount: int):
	if coins >= amount:
		coins -= amount
		coins_changed.emit(coins)
