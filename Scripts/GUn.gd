extends Node2D
@onready var switch_weapons = $"Switch Weapons"

var Pistol = {dmg=20, fire_Rate = 0.5, range = 2000, Sprite = 0, mag = 8, reload = 3.0, sound = preload("res://Assets/smg_audio.mp3")}
var SMG = {dmg = 5, fire_Rate = 0.1, range = 500, Sprite = 1, mag = 30, reload = 2.0, sound = preload("res://Assets/smg_audio.mp3")}
var Revolver = {dmg = 100, fire_Rate = 1.0, range = 2000, Sprite = 2, mag = 5, reload = 2.5, sound = preload("res://Assets/smg_audio.mp3")}

@export var Current_Weapon: Dictionary
signal weapon_changed

func _ready():
	Current_Weapon = SMG
#	_emit_weapon_properties(Current_Weapon)


func _physics_process(delta):
	if not is_multiplayer_authority(): return
	if switch_weapons.time_left > 0.0: return
	if Input.is_action_just_pressed("wep1"):
		Current_Weapon = Pistol
		switch_weapons.start()
		emit_signal("weapon_changed")
	if Input.is_action_just_pressed("wep2"):
		Current_Weapon = SMG
		switch_weapons.start()
		emit_signal("weapon_changed")
	if Input.is_action_just_pressed("wep3"):
		Current_Weapon = Revolver
		switch_weapons.start()
		emit_signal("weapon_changed")
	_emit_weapon_properties(Current_Weapon)
func _emit_weapon_properties(EquippedWeapon):
	$Sprite2D.set_frame(EquippedWeapon.Sprite)
	
#	DMG.emit(EquippedWeapon.dmg)
#	RATE_OF_FIRE.emit(EquippedWeapon.fire_Rate)
#	RANGE.emit(EquippedWeapon.range)
