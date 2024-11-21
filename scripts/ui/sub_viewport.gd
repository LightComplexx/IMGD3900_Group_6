extends SubViewport

@onready var camera = $Camera2D
@onready var player = $"../../.."

func _physics_process(delta: float) -> void:
	camera.position = player.position
