extends Sprite2D
@onready var point: Sprite2D = $Point
@onready var stick_width = self.texture.get_width() / 2.0
var on_draging = -1
var tween: Tween

func _ready():
	pass # Replace with function body.


func _input(event):
	if GlobalConst.is_mobile:
		if (event is InputEventScreenDrag) or (event is InputEventScreenTouch and event.is_pressed()):
			var mouse_position = (event.position - global_position).length()
			if mouse_position <= stick_width or on_draging == event.index:
				on_draging = event.index
				point.global_position = event.position
				if point.position.length() > stick_width:
					point.position = point.position.normalized() * stick_width
		if event is InputEventScreenTouch and not event.is_pressed():
			if on_draging == event.index:
				_set_center()
#	else:
		
#	match OS.get_name():
#		"Android", "iOS":

#		"Windows", "UWP", "Web", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
#			if (event is InputEventMouseButton and event.is_pressed()):
#				var mouse_position = (event.position - global_position).length()
#				if mouse_position <= stick_width or on_draging == event.button_index:
#					on_draging = event.button_index
#					point.global_position = event.position
#					if point.position.length() > stick_width:
#						point.position = point.position.normalized() * stick_width
#			if (event is InputEventMouseButton and not event.is_pressed()):
#					_set_center()
	
	

func _set_center():
	on_draging = -1
	if tween:
		tween.stop()
	tween = get_tree().create_tween()
	tween.tween_property(point, "position", Vector2.ZERO, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func get_node_pos() -> Vector2:
	return point.position.normalized()
