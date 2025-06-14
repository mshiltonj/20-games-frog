extends Area2D

func is_point_on_platform(point: Vector2) -> bool:
	var is_on_platform : bool = false
	for collision_shape : Node in self.get_children():
		if collision_shape is CollisionShape2D:
			print(collision_shape.shape.get_rect())
			if collision_shape.shape.overlaps_point(point):
				pass
			if collision_shape.shape.get_rect().has_point(point):
				is_on_platform = true
				break
	return is_on_platform
