extends TextureRect

@onready var reference_rect = $ReferenceRect

var select: bool = false :
	set(value):
		select = value
		if value:
			reference_rect.show()
		else:
			reference_rect.hide()
					
func initialize(_texture: Texture) -> void:
	self.texture = _texture
	

