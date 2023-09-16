extends CharacterBody2D
	
var dashOffCD = true
var doubleJumpOffCD = true
var MAX_HP = 200
var Current_HP = MAX_HP

const dashSpeed = 1500
signal objectiveTaken
const SPEED = 300.0
const JUMP_VELOCITY = -750.0
const wallJumpSpeedMultiplier = 4
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 3000
var is_reloading = false
var range = 2000
var Magazine_size
var bullets_fired = 0
var fire_rate
var reload_time
var audio

@onready var progress_bar = $HP
@onready var coyote = $Coyote
@onready var starting_position = global_position
@onready var viewRect = get_viewport_rect()
@onready var dash_duration = $dashDuration
@onready var hitscan = $hitscan
@onready var label = $CanvasLayer/ColorRect/Label
@onready var reloader = $CanvasLayer/ColorRect/reloader



var original_gravity = 3000
var direction
const acceleration = 50.0
var can_fire = true
@export var bullet : PackedScene
func _ready():
	$HitMarks.hide()
	progress_bar.max_value = MAX_HP
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
func _process(delta):
	if not is_multiplayer_authority(): return
	hitscan.rotation = get_angle_to(get_global_mouse_position())
	hitscan.target_position.x = range
	update_weapon_stats.rpc()
	
	$gun.look_at(get_global_mouse_position())
	
	
func _physics_process(delta):
	if not is_multiplayer_authority(): return
	var whatishitting = hitscan.get_parent()
	update_weapon_stats.rpc()
	
	$Can_Fire.set_wait_time(fire_rate)
	label.text = str(Magazine_size-bullets_fired)
	reloader.max_value = reload_time
	reloader.set_visible(is_reloading)
	reloader.value = reload_time - $reload_time.time_left
	$reload_time.set_wait_time(reload_time)
	if $Can_Fire.time_left == 0.0 and is_reloading == false:
		can_fire = true
	else:
		can_fire = false
	if (bullets_fired >= Magazine_size and $reload_time.time_left == 0.0 and is_reloading == false) or Input.is_action_just_pressed("reload"):
		is_reloading = true
		$reload_time.start()
		

#	print(whatishitting.get_dmg())
#	hitscan.get_parent().update_weapon_stats.rpc_id(hitscan.get_parent().get_multiplayer_authority())
	if Input.is_action_pressed("fire") and can_fire:
		$AudioStreamPlayer.play()
		var shooter = hitscan.get_parent()
		var shooter_dmg = shooter.get_dmg()	
		if hitscan.is_colliding() and hitscan.get_collider().get_class() == "CharacterBody2D":			
			var whatgothit = hitscan.get_collider()
			$Can_Fire.start()
			bullets_fired +=1
#				whatishitting.update_weapon_stats.rpc_id(whatishitting.get_multiplayer_authority())
			if shooter.get_range() >= abs(get_global_position().distance_to(whatgothit.get_global_position())):
				whatgothit.got_hit.rpc_id(whatgothit.get_multiplayer_authority(), shooter_dmg)
		elif hitscan.is_colliding() and hitscan.get_collider().get_class() != "CharacterBody2D":
			$Can_Fire.start()
			bullets_fired +=1
			
	if not is_on_floor():
		velocity.y += gravity * delta
		if dashOffCD and Input.is_action_just_pressed("abilityDash"):
			DASH()
		if doubleJumpOffCD and Input.is_action_just_pressed("ui_up"):
			DOUBLE_JUMP()
	else: 
		doubleJumpOffCD = true
		dashOffCD = true
	direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	if is_on_floor() or coyote.time_left >0.0:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	if $WallDetectorRight.is_colliding() and not is_on_floor():
		if Input.is_action_just_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			velocity.y = JUMP_VELOCITY/1.5
			velocity.x = direction * SPEED * wallJumpSpeedMultiplier
	if $WallDetectorLeft.is_colliding() and not is_on_floor():
		if Input.is_action_just_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			velocity.y = JUMP_VELOCITY/1.5
			velocity.x = direction * SPEED * wallJumpSpeedMultiplier
	var was_on_floor = is_on_floor()
	move_and_slide()
	hitscan.set_collide_with_bodies(can_fire)
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)
	
	var just_left_ledge = was_on_floor  and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote.start()

		
func DASH():
		
		dashOffCD = false
		velocity.x = direction * dashSpeed
func DOUBLE_JUMP():
	
		velocity.y = JUMP_VELOCITY
		doubleJumpOffCD = false

@rpc("any_peer")
func got_hit(shooter_dmg):
	
	Current_HP -= shooter_dmg	
	if Current_HP <= 0:
		Current_HP = MAX_HP
		position = Vector2(21, 21)
	
	var frame = randi_range(0, 2)
	$HitMarks.set_frame(frame)
	$HitMarks.show()
	progress_bar.value = Current_HP
	await get_tree().create_timer(0.2).timeout
	$HitMarks.hide()
@rpc("any_peer", "call_local")
func SHOOT():
	if not is_multiplayer_authority(): return
	if not $Can_Fire.time_left > 0.0:
		$Can_Fire.start()
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = get_global_position()
		bullet_instance.rotation = get_angle_to(get_global_mouse_position())		
		get_parent().add_child(bullet_instance)


#func _on_good_stuff_detector_area_entered(area):
#	emit_signal("objectiveTaken")

@rpc("any_peer", "call_local")
func update_weapon_stats():
	fire_rate = $gun.Current_Weapon.fire_Rate
	Magazine_size = $gun.Current_Weapon.mag
	reload_time = $gun.Current_Weapon.reload
	audio = $gun.Current_Weapon.sound
@rpc("any_peer")
func get_dmg():
	return $gun.Current_Weapon.dmg
@rpc("any_peer")
func get_range():
	return $gun.Current_Weapon.range


func _on_reload_time_timeout():
	is_reloading = false
	bullets_fired = 0


func _on_gun_weapon_changed():
	is_reloading = false
	bullets_fired = 0
