## 玩家信息保存
extends Node
## 当前的hp
var hp: int = 20
## 最大hp
var max_hp: int = 100
var weapons: Array[Node2D] = []
var equipped_weapon_index = 0
## 当前所在楼层位置
var num_floor = 0
