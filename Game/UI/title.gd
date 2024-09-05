extends Node2D

signal new_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartMenu.start_game.connect(_on_start_game)


func _on_start_game() -> void:
	new_game.emit()
