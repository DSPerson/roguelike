extends Node
## 状态机
class_name FiniteStateMachine

# 状态机存储属性
var states: Dictionary = {}
var previous_state: int = -1
var state: int = -1 :
	set(value):
		_exit_state(state)
		previous_state = state
		state = value
		_enter_state(previous_state, value)
	get:
		return state

@onready var parent: Character = get_parent()
@onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")


func _physics_process(delta):
	if state != -1:
		_state_logic(delta)
		var transition = _get_transition()
		if transition != -1:
			state = transition
		
# 每帧调用 移动 什么的
func _state_logic(_delta: float) -> void:
	pass

# 用来执行 当一个状态完毕后, 切换会默认状态
# 比如播放 砍敌人动画, 砍完了 就变成idle状态了
func _get_transition() -> int:
	return -1
	
func _add_state(new_state: String) -> void:
	states[new_state] = states.size()
	
func _enter_state(_previous_state: int, _new_state: int):
#	print("_enter_state", "退出" + str(_previous_state), "进入" + str(new_state))
	pass
	
func _exit_state(_state_exited: int):
#	print("_exit_state", "退出" + str(_state_exited))
	pass
