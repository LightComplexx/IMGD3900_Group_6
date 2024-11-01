extends Node2D

var bar_green = preload("res://sprites/ui/health_bar_green.png")
var bar_yellow = preload("res://sprites/ui/health_bar_yellow.png")
var bar_red = preload("res://sprites/ui/health_bar_red.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		node.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_rotation = 0


func update_healthbar(value) -> void:
	$HealthBar.texture_progress = bar_green
	
	if value < 100:
		$HealthBar.show()
	if value < 60:
		$HealthBar.texture_progress = bar_yellow
	if value < 25:
		$HealthBar.texture_progress = bar_red
		
	$HealthBar.value = value
