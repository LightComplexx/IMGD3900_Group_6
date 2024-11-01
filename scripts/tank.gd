extends CharacterBody2D

signal shoot
signal health_changed
signal dead

@export var Bullet:PackedScene
@export var speed = 100
@export var rotation_speed = 1.0
@export var gun_cooldown = 0.4
@export var health = 100

var can_shoot = true
var alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GunTimer.wait_time = gun_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not alive:
		return
	control(delta)
	move_and_slide()

func control(_delta):
	pass


func _on_shoot() -> void:
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		emit_signal("shoot", Bullet, $Turret/Muzzle.global_position, dir)
		


func _on_gun_timer_timeout() -> void:
	can_shoot = true
