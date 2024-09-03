extends Node

@export var save_data: SaveData

func _ready() -> void:
	save_data = SaveData.load_or_create()