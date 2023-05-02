## 配置一些不变的信息
extends Node
	
## 一些基础不变量和便利函数
var random: RandomNumberGenerator = RandomNumberGenerator.new()
## 临时存储变量
var _is_mobile = -1
## 是否是在移动端
var is_mobile: bool:
	get:
		if _is_mobile != -1:
			return true if _is_mobile == 1 else false
		if OS.get_name() == "iOS" || OS.get_name() == "Android":
			_is_mobile = 1
		else:
			_is_mobile = 0
		return true if _is_mobile == 1 else false
## 碰撞检测Layer 层级
## set_collision_mask_value(World, true) 用这个
enum CollistionMaskLayer {
	World = 1,
	Player = 2,
	Enemy = 3,
	Furntiture = 4,
	Projectile = 5,
}

## 数值
## 判断collision_layer 用这个
enum CollistionMaskLayerValue {
	World = 1,
	Player = 2,
	Enemy = 4,
	Furntiture = 8,
	Projectile = 16,
}
## 一管药剂
const PickUpGoodIdPotionRedHp = "potion_red_hp"

## 添加一个silbing 到 current 之上
func add_sibling_above(current: Node, silbing: Node) -> void:
	current.get_parent().get_child(current.get_index() - 1).add_sibling(silbing)
