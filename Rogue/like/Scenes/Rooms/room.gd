extends Node2D
## 房间信息
class_name DugeonRoom

## 产生爆炸效果的场景
const SPAWN_EXPLISTION_SCENE: PackedScene = preload("res://Scenes/Enemy/spawn_explosion.tscn")
## 敌人场景
const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATER": preload("res://Scenes/Enemy/Fly/fly_creature.tscn"),
	"GOBLIN_CREATER": preload("res://Scenes/Enemy/Goblin/goblin.tscn"),
	"SLIME_BOSS_CREATER": preload("res://Scenes/Enemy/Bosses/slime_boss.tscn"),
}
## 敌人数量
var num_enemies: int 

@export_group("入口设置")
## 入口选择瓷砖在瓦片中位置
@export var entrance_models: Array[EntranceModel] = []
## 是否是boss房间
@export var boss_room = false
## 门口距离当前房间距离是2个tileMep tileSize
@export var door_distance_to_exit = Vector2i.UP * 2
## 创建大量敌人使用, 测试时候使用
var start_spawn_enemy = false
var current_enemy_count: int = 0
## 测试生成敌人数量
@export var enemies_count: int = 0

@onready var tile_map = $NavigationRegion2D/TileMap
@onready var entrance = $Entrance
@onready var doors = $Doors
@onready var enemy_positions = $EnemyPositions
@onready var player_detector = $PlayerDetector
@onready var enemies = $Enemies

var is_opened = false
var random = RandomNumberGenerator.new()
var layer_0_positions: Array[Vector2i] = []

func _ready():
	num_enemies = enemy_positions.get_child_count()
	
func _open_door() -> void:
	if is_opened:
		return
	is_opened = true
	for door in doors.get_children():
		door.open()
	_close_entrance(true)
	
func _close_entrance(remove: bool = false) -> void:
	assert(not entrance_models.is_empty())
	for entry in entrance.get_children():
		var child_coord = tile_map.local_to_map(entry.position)
		for entrance_model in entrance_models:
			if not remove:
				tile_map.set_cell(entrance_model.layer_index, child_coord + entrance_model.direction, 0, entrance_model.alta)
			else:
				tile_map.set_cell(entrance_model.layer_index, child_coord + entrance_model.direction, -1, entrance_model.alta)
			
#func _physics_process(_delta):
#	if Engine.get_physics_frames() % 3 == 0:
#		_spawn_enemy2()

func _spawn_enemy2() -> void:
	if not start_spawn_enemy or current_enemy_count >= enemies_count:
		start_spawn_enemy = false
		return
	if layer_0_positions.is_empty():
		layer_0_positions = tile_map.get_used_cells(0)
	var last = enemies_count - current_enemy_count
	last = min(10, last)
	var max_size = tile_map.get_used_rect().size
	for d in range(0, last):
		var l = random.randi_range(0, layer_0_positions.size() - 1)
		var pp = layer_0_positions[l]
		while ((pp.x == 0) or 
			(pp.y <= 2) or 
			(pp.x == max_size.x - 1) or
			(pp.y == max_size.y - 1)):
			l = random.randi_range(0, layer_0_positions.size() - 1)
			pp = layer_0_positions[l]
		var cell_position = tile_map.map_to_local(pp)
#		cell_position = tile_map.to_global(cell_position)
		var enemy: Enemy
#		var r = random.randi()
#		if r % 2 == 0:
#			enemy = ENEMY_SCENES.FLYING_CREATER.instantiate()
#		else:
		enemy = ENEMY_SCENES.GOBLIN_CREATER.instantiate()
#		enemy.tree_exited.connect(_on_enemy_killed)
		enemy.position = cell_position
		call_deferred("add_child", enemy)	
		var explosion = SPAWN_EXPLISTION_SCENE.instantiate()
		explosion.position = cell_position
		call_deferred("add_child", explosion)
		current_enemy_count += 1
	
	
func _spawn_enemy() -> void:
	for enemy_position in enemy_positions.get_children():
		var enemy: Enemy
		if boss_room:
			enemy = ENEMY_SCENES.SLIME_BOSS_CREATER.instantiate()
		else:
			var r = random.randi()
			if r % 2 == 0:
				enemy = ENEMY_SCENES.FLYING_CREATER.instantiate()
			else:
				enemy = ENEMY_SCENES.GOBLIN_CREATER.instantiate()
		enemy.position = enemy_position.position
		enemies.call_deferred("add_child", enemy)
		
		var explosion = SPAWN_EXPLISTION_SCENE.instantiate()
		explosion.position = enemy_position.position
		enemies.call_deferred("add_child", explosion)

func _on_enemy_killed() -> void:
	print("----->", enemies.get_child_count())
	if enemies.get_child_count() == 0:
		_open_door()


func _on_player_detector_area_entered(_area):
	if num_enemies > 0:
		player_detector.queue_free()
		_close_entrance()
		start_spawn_enemy = true
		_spawn_enemy()
	else:
		_close_entrance()
		_open_door()
