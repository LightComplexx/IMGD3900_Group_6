extends CharacterBody2D

signal health_changed
signal dead

@export var Bullet:PackedScene
@export var speed:int
@export var rotation_speed:float
@export var gun_cooldown:float
@export var health:int

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

func control(delta):
	pass
