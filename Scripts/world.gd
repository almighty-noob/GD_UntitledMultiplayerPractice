extends Node2D
@onready var address_2 = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Address2

@onready var menu = $CanvasLayer/PanelContainer
@onready var address = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Address
@export var Player: PackedScene
var enet_peer = ENetMultiplayerPeer.new()
const PORT = 7680
func _on_host_pressed():
	menu.hide()
	enet_peer.create_server(PORT)
	print(enet_peer.get_host())
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(ADD_PLAYER)
	ADD_PLAYER(multiplayer.get_unique_id())
	
func _on_join_pressed():
#	if address.text == "": return
	var cPORT = address_2.text
	menu.hide()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer

func ADD_PLAYER(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	get_node("Level1").add_child(player)
