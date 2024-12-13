extends Area2D

@export var speed = 750
@export var damage = 10
@export var lifetime = 2
@export var steer_force = 0

var velocity = Vector2()
var acceleration = Vector2()
var target = null


func start(pos: Vector2, dir: Vector2, tar = null):
	position = pos
	rotation = dir.angle()
	$Lifetime.wait_time = lifetime
	velocity = dir * speed
	$Lifetime.start()
	target = tar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(target):
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
	position += velocity * delta

func seek():
	var desired = (target.position - position).normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force
	return steer


func explode():
	target = null
	velocity = Vector2.ZERO
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.show()
	$Explosion.play()



func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.has_node("ArmorSound"):
			body.get_node("ArmorSound").play()
		explode()
	else:
		explode()

func _on_lifetime_timeout() -> void:
	explode()


func _on_area_entered(area: Area2D) -> void:
	explode()


func _on_explosion_animation_finished() -> void:
	queue_free()
