extends CanvasLayer

## 23 - 97
const MIN_HEALTH: int = 23
const MAX_HEALTH: int = 97

var hpProgress: float = 0

@onready var player: Character = get_parent().get_node("Player")
@onready var health_bar = $MarginContainer/HBoxContainer/HealthBar

@onready var label = $MarginContainer/HBoxContainer/Label
@onready var inventory = $PanelContainer/Inventory

var inventory_select_index = -1
var inventory_item = preload("res://Scenes/UI/inventory_item.tscn")

@onready var tween: Tween :
	get:
		return get_tree().create_tween()
		
# Called when the node enters the scene tree for the first time.
func _ready():
	player.hp_changed.connect(_on_player_hp_changed)
	player.max_hp_changed.connect(_on_player_max_hp_changed)
	player.signal_pick_up_weapon.connect(_on_player_pick_up_weapon)
	player.signal_drop_weapon.connect(_on_player_drop_weapon)
	player.signal_switch_weapon.connect(_on_player_switch_weapon)
	

func _update_health_bar(new_value: int, time: float = 0.3) -> void:
	tween.tween_property(health_bar, "value", new_value, time).set_trans(Tween.TRANS_QUINT)


func _on_player_hp_changed(new):
	_update_health_bar(hpProgress * new + MIN_HEALTH)

func _on_player_max_hp_changed(new):
	hpProgress = (MAX_HEALTH - MIN_HEALTH) / float(max(new, 1))
	_on_player_hp_changed(player.hp)
	
func _on_player_pick_up_weapon(texture: Texture) -> void:
	var item = inventory_item.instantiate()
	inventory.add_child(item)
	item.initialize(texture)
	if inventory_select_index != -1:
		inventory.get_children()[inventory_select_index].select = false
	inventory_select_index = inventory.get_child_count() - 1
	item.select = true
	
func _on_player_drop_weapon() -> void:
	var index = inventory_select_index
	inventory.remove_child(inventory.get_children()[index])
	if inventory.get_child_count() == 0:
		inventory_select_index = -1
	else:
		inventory_select_index -= 1
		if inventory_select_index < 0:
			inventory_select_index = inventory.get_child_count() - 1
	if inventory_select_index >= 0:
		inventory.get_children()[inventory_select_index].select = true
	

func _on_player_switch_weapon(index: int) -> void:
	inventory.get_children()[inventory_select_index].select = false
	inventory_select_index = index
	inventory.get_children()[inventory_select_index].select = true
	print_debug("选中", index)

func _process(_delta):
	label.text = str(Engine.get_frames_per_second()) + " " + str(get_tree().get_nodes_in_group("enemy").size())

