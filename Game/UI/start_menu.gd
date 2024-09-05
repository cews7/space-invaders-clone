extends Control

signal start_game

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	start_game.emit()
