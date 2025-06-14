extends RefCounted
class_name ObjectPool

var scene : PackedScene
var max_pool_size : int
var pool : Array = []
var pool_id : int 
# -1 means no size limit
func _init(packed_scene : PackedScene, initial_size : int = 5,
 initial_max_pool_size: int = -1) -> void:
	self.pool_id = randi()
	self.scene = packed_scene
	self.max_pool_size = initial_max_pool_size
	for idx in range(0, initial_size):
		self._add_item()

func _add_item() -> void:	
	print("adding new item to pool")
	var node : Node = self.scene.instantiate()
	if "pool_id" in node:
		node.pool_id = self.pool_id
	self.pool.push_front(node)
	
func get_item() -> Node2D:
	print("getting item from pool")
	if self.pool.size() == 0:
		_add_item()
	return self.pool.pop_back()
	
func return_item(item : Node) -> void:
	print("returning item to pool")
	self.pool.push_front(item)
