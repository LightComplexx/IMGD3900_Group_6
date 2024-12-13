extends Control

func _ready() -> void:
	$MainTheme.play(Globals.song_position)

func _on_back_pressed() -> void:
	Globals.song_position = $MainTheme.get_playback_position() + AudioServer.get_time_since_last_mix()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
