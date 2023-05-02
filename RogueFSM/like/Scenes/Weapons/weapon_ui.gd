extends Control

@onready var ability_icon = get_node("AbilityIcon")
## 动画效果
var cool_down_tween: Tween

func recharge_ability_animation(time: float):
	if (cool_down_tween):
		cool_down_tween.kill()
		cool_down_tween = null
	cool_down_tween = get_tree().create_tween()
	cool_down_tween.bind_node(self)
	ability_icon.value = 100
	cool_down_tween.tween_property(ability_icon, "value", 0, time)
