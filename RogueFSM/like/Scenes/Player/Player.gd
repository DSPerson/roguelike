extends Character

class_name Player
## 拾取武器
signal signal_pick_up_weapon(texture)
signal signal_drop_weapon()
signal signal_switch_weapon(index)

## 跑动烟雾
const DUST_SCENE = preload("res://Scenes/Player/dust.tscn")
## 鼠标滚轮方向
enum MOUSE_WHEEL_DIRECTION {
	UP,
	DOWN
}
## 相机
@onready var camera_2d = $Camera2D
## 武器系统
@onready var weapons: Node2D = $Weapons
## 当前的武器
var current_weapon: Weapon
## 生成跑动烟雾效果
@onready var dust_position = $DustPosition

var joystick_position: Vector2 = Vector2.ZERO

func _ready():
	camera_2d.make_current()
	_restore_previous_state()
	
## 获取玩家之前的状态
## 初始挂载武器
func _restore_previous_state() -> void:
	self.max_hp = PlayerSaveData.max_hp
	self.hp = PlayerSaveData.hp
	if not PlayerSaveData.weapons.is_empty():
		for item in PlayerSaveData.weapons:
			item = item.duplicate()
			item.hide()
			item.position = Vector2.ZERO
			weapons.add_child(item)
		current_weapon = weapons.get_child(PlayerSaveData.equipped_weapon_index)
		current_weapon.show()
	else:
		current_weapon = weapons.get_child(0)
	PlayerSaveData.weapons.append(current_weapon.duplicate())
	set_up_current_weapon(current_weapon, true)
	emit_signal("signal_pick_up_weapon", current_weapon.get_texture())
	
func _process(_delta: float) -> void:
# x < 0 鼠标在角色左侧
# x > 0 鼠标在角色右侧
# 就是向量的方向
	var mouse_direction: Vector2 = Vector2.ZERO
	if GlobalConst.is_mobile:
		mouse_direction = joystick_position
	else:
		mouse_direction = (get_global_mouse_position() - global_position).normalized()
	## 玩家的左右翻转
	if mouse_direction.x > 0 and animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = false
	elif mouse_direction.x < 0 and !animated_sprite_2d.flip_h:
		animated_sprite_2d.flip_h = true
	## 武器的方向问题
	if current_weapon:
		current_weapon.move(mouse_direction)

## 输入监听
func get_input() -> void:
	if not GlobalConst.is_mobile:
		move_direction = Vector2.ZERO
		if Input.is_action_pressed("ui_down"):
			move_direction += Vector2.DOWN
		elif Input.is_action_pressed("ui_up"):
			move_direction += Vector2.UP
		elif Input.is_action_pressed("ui_left"):
			move_direction += Vector2.LEFT
		elif Input.is_action_pressed("ui_right"):
			move_direction += Vector2.RIGHT
	if current_weapon:
		if not GlobalConst.is_mobile:
			current_weapon.get_input()
		else:
			pass
		## 如果不是busy阶段
		if not current_weapon.is_busy():
			if Input.is_action_just_released("ui_previous_weapon"):
				_switch_weapon(MOUSE_WHEEL_DIRECTION.UP)
			elif Input.is_action_just_released("ui_next_weapon"):
				_switch_weapon(MOUSE_WHEEL_DIRECTION.DOWN)
			elif Input.is_action_just_pressed("ui_throw"):
				if weapons.get_child_count() != 0:
					drop_weapon()
		
## 死亡
func dead_action():
	camera_2d.enabled = false
	super.dead_action()
## 取消攻击
func cancel_attack(force: bool = false):
	if current_weapon:
		current_weapon.cancel_attack(force)


## 捡起武器
func pick_up_weapon(weapon: Weapon):
	PlayerSaveData.weapons.append(weapon.duplicate())
	PlayerSaveData.equipped_weapon_index = PlayerSaveData.weapons.size() - 1
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	if current_weapon:
		current_weapon.hide()
		current_weapon.cancel_attack()
		set_up_current_weapon(current_weapon, false)
	current_weapon = weapon
	current_weapon.pick_up_reset_animation()
	set_up_current_weapon(current_weapon, true)
	emit_signal("signal_pick_up_weapon", current_weapon.get_texture())

## 切换武器
func _switch_weapon(dir: MOUSE_WHEEL_DIRECTION, _index: int = -1) -> void:
	var index = 0
	if _index == -1:
		index = current_weapon.get_index()
	else:
		index = _index
	if dir == MOUSE_WHEEL_DIRECTION.UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > (weapons.get_child_count() - 1):
			index = 0
	current_weapon.hide()
	set_up_current_weapon(current_weapon, false)
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	set_up_current_weapon(current_weapon, true)
	PlayerSaveData.equipped_weapon_index = index
	emit_signal("signal_switch_weapon", index)
		
## 扔掉武器	
func drop_weapon():
	var index = current_weapon.get_index()
	PlayerSaveData.weapons.remove_at(index)
	var weapon = current_weapon
	weapons.call_deferred("remove_child", weapon)
	var p = get_parent()
	p.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", p)
	call_deferred("check_weapons_empty")
	await weapon.tree_entered
	var throw_dir: Vector2 = position.direction_to(get_global_mouse_position())
	weapon.interpolate_pos(position, position + throw_dir * 50)
	emit_signal("signal_drop_weapon")
	if weapons.get_child_count() > 0:
		_switch_weapon(MOUSE_WHEEL_DIRECTION.UP, index)
	else:
		set_up_current_weapon(current_weapon, false)
	weapon.show()

## 检测武器是否为空了
func check_weapons_empty():
	if weapons.get_child_count() == 0:
		current_weapon = null
		
func set_up_current_weapon(weapon: Weapon, use: bool):
	if use:
		weapon.weapon_skill.connect(current_weapon_use_skill)
	else:
		weapon.weapon_skill.disconnect(current_weapon_use_skill)
		
		
func current_weapon_use_skill(time: float):
	emit_signal("weapon_skill", time)
# ****** #
## 生成跑动烟雾效果
func spawn_dust() -> void:
	var dust = DUST_SCENE.instantiate()
	dust.position = dust_position.global_position
	GlobalConst.add_sibling_above(self, dust)

## 捡到物品
func pick_up_goods(identifier: String):
	match identifier:
		GlobalConst.PickUpGoodIdPotionRedHp:
			hp += 100
