extends Node

@export var save_data: SaveData
@export var show_game_launcher: bool = true

func _ready() -> void:
	save_data = SaveData.load_or_create()