extends CharacterBody2D

signal shoot
signal health_changed
signal dead

@export var Bullet:PackedScene
@export var max_speed = 100.0
@export var rotation_speed = 2.0
@export var gun_cooldown = 0.4
@export var max_health = 100

var can_shoot = true
var alive = true
var health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	$GunTimer.wait_time = gun_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not alive:
		return
	control(delta)
	move_and_slide()

func control(_delta: float) -> void:
	pass


func take_damage(amount: float) -> void:
	health -= amount
	emit_signal("health_changed", health * 100/max_health)
	if health <= 0:
		explode()


func explode() -> void:
	queue_free()

func _on_shoot() -> void:
	if can_shoot:
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2(1, 0).rotated($Turret.global_rotation)
		emit_signal("shoot", Bullet, $Turret/Muzzle.global_position, dir)
		
		$Turret.translate(Vector2(-10,0)) #turret recoil, value is draft
		#TODO: Make the turret return at a set rate
		#TODO: Scale the recoil amount by projectile damage
		


func _on_gun_timer_timeout() -> void:
	can_shoot = true
