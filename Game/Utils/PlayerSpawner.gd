extends Node2D

@onready var player_scene: PackedScene = preload("res://Game/Entities/Player/player.tscn")

var player: Object = null

func _process(_delta: float) -> void:
	if player == null and get_parent().player_lives_remaining > 0:
		var new_player: CharacterBody2D = player_scene.instantiate()
		new_player.position = position
		new_player.name = "Player"
		get_parent().add_child(new_player)
		player = new_player
		




