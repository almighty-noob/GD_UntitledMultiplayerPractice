extends RigidBody2D


var bullet_speed = 4000

func _physics_process(delta):

	apply_central_impulse(Vector2(bullet_speed, 0).rotated(rotation))
#func _physics_process(delta)



func _on_area_2d_body_entered(body):
	queue_free()
