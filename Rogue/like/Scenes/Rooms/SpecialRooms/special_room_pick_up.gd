## 特殊房间带有可拾取道具
extends DugeonRoom
## 可拾取道具
@onready var pick_up_area = $PickUpArea


func _ready():
	connect_pick_up_area()
	
func connect_pick_up_area():
	for area in pick_up_area.get_children():
		area.pick_up_action.connect(pick_up_goods)

func pick_up_goods(identifier: String):
	var player: Player = get_tree().current_scene.get_node("Player")
	player.pick_up_goods(identifier)
