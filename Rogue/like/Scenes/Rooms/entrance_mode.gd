extends Resource
class_name EntranceModel

## 精灵集位置
@export var alta: Vector2i = Vector2i(-1, -1)
## layer层级
@export var layer_index: int = -1
## 放在所在位置的反向 默认下面
@export var direction: Vector2i = Vector2i.DOWN



func _init():
	pass
