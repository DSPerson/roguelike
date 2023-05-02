extends DugeonRoom

const WEAPONS: Array[String] = [
#	preload("res://Scenes/Weapons/war_hammer.tscn").resource_path
	"res://Scenes/Weapons/war_hammer.tscn"
]
## 宝箱
const TREASURES = preload("res://Scenes/Furniture/treasure_weapon_box.tscn")

## 生成武器位置
@onready var weapon_pos = $WeaponPos

func _ready():
	_generate_weapon()

func _generate_weapon() -> void:
#	var weapon = WEAPONS[GlobalConst.random.randi_range(0, WEAPONS.size() - 1)].instantiate()
#	weapon.position = weapon_pos.position
#	weapon.can_on_floor = true
#	add_child(weapon)
	var treasure = TREASURES.instantiate()
	treasure.position = weapon_pos.position
	treasure.pick_up_goods = WEAPONS[GlobalConst.random.randi_range(0, WEAPONS.size() - 1)]
	treasure.speed = 150
	add_child(treasure)
	
	
