extends Node2D
## 开始
const SPAWN_ROOMS: Array[Resource] = [
#	preload("res://Scenes/Rooms/Level_0/level_0_0_rooms.tscn"),
	preload("res://Scenes/Rooms/Level_0/level_0_1_rooms.tscn")
]
## 中间
const INTERMEDIATE_ROOMS: Array = [
	preload("res://Scenes/Rooms/room_0.tscn"),
#	preload("res://Scenes/Rooms/room_1.tscn"),
#	preload("res://Scenes/Rooms/room_2.tscn"),
]
## 结尾
const END_ROOMS: Array = [
	preload("res://Scenes/Rooms/end/end_room_0.tscn")
]
## 特殊房间
const SPECOAL_ROOMS: Array = [
	preload("res://Scenes/Rooms/SpecialRooms/special_room_0.tscn"),
	preload("res://Scenes/Rooms/SpecialRooms/special_room_1.tscn")
]
## boss房间
const BOSS_ROOMS: Array = [
	preload("res://Scenes/Rooms/BossRooms/boss_room_0.tscn")
]
## 瓦块尺寸
const TILE_SIZE: int = 16

## 地板
@export_category("地板")
@export var floor_tile: Vector2i = Vector2i.ZERO
## 左地板
@export var left_floor_tile: Vector2i = Vector2i.ZERO
## 右地板
@export var right_floor_tile: Vector2i = Vector2i.ZERO
@export_category("层级")
## 层级
@export var num_levels = 5
@export_range(2, 100, 1) var corridor_range = 7
## 玩家
@onready var player: Character = get_parent().get_node("Player")
## 是否生成boss房间
var generate_booss_floor = false
var rng = RandomNumberGenerator.new()
func _ready():
	PlayerSaveData.num_floor += 1
	if PlayerSaveData.num_floor == 3:
		generate_booss_floor = true
		num_levels = 3
	_spawn_rooms()

## 生成房间
func _spawn_rooms() -> void:
	var previous_room: DugeonRoom
	var tileMap: NodePath = "NavigationRegion2D/TileMap"
	var special_room_spawned = true
	for i in num_levels:
		var room: Node2D
		if i == 0:
			## 头
			var o = rng.randi_range(0, SPAWN_ROOMS.size() - 1)
			room = SPAWN_ROOMS[o].instantiate()
			player.position = room.get_node("PlayerPosition").position
		else:
			## 尾
			if i == num_levels - 1:
				var o = rng.randi_range(0, END_ROOMS.size() - 1)
				room = END_ROOMS[o].instantiate()
			else:
			## 中间
				if generate_booss_floor:
					var o = rng.randi_range(0, BOSS_ROOMS.size() - 1)
					room = BOSS_ROOMS[o].instantiate()
				else:
					if not special_room_spawned and rng.randi() % 3 == 0:
#					if not special_room_spawned:
						var o = rng.randi_range(0, SPECOAL_ROOMS.size() - 1)
						room = SPECOAL_ROOMS[o].instantiate()
						special_room_spawned = true
					else:
						var o = rng.randi_range(0, INTERMEDIATE_ROOMS.size() - 1)
						room = INTERMEDIATE_ROOMS[o].instantiate()
			# 链接
			var previous_tileMap: TileMap = previous_room.get_node(tileMap)
			var previuos_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var door_in_map_position = previous_tileMap.local_to_map(previuos_door.position) 
			var exit_tile_pos: Vector2i = door_in_map_position + previous_room.door_distance_to_exit
			var corridor_height: int = rng.randi_range(2, corridor_range)
			for y in corridor_height:
				previous_tileMap.set_cell(0, exit_tile_pos + Vector2i(1, -y), 0, right_floor_tile)
				previous_tileMap.set_cell(0, exit_tile_pos + Vector2i(0, -y), 0, floor_tile)
				previous_tileMap.set_cell(0, exit_tile_pos + Vector2i(-1, -y), 0, floor_tile)
				previous_tileMap.set_cell(0, exit_tile_pos + Vector2i(-2, -y), 0, left_floor_tile)
			# 移动位置,
			var room_tileMap: TileMap = room.get_node(tileMap)
			var p = previuos_door.global_position
			# 上
			p += Vector2.UP * (room_tileMap.get_used_rect().size.y) * TILE_SIZE + Vector2.UP * (corridor_height + 1) * TILE_SIZE + Vector2(0, -0.3)
			# 左
			p += Vector2.LEFT * room_tileMap.local_to_map(room.get_node("Entrance/Marker2D2").position).x * TILE_SIZE
			room.position = p
		add_child(room)
		previous_room = room
