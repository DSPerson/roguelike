## 一个Sprite 带一个AnimationPlayer
extends Sprite2D
class_name EffectOnlyAnimationPlayer
## 动画
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## 播放
func reset_play():
	if not animation_player.is_playing():
		animation_player.play("RESET")
		animation_player.play("animation")
	
