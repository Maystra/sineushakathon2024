extends StaticBody3D

enum BrickType {
	BRICK1, BRICK2, BRICK3
}
enum BrickBonus {
	NONE, SPEED, SLOW, CHARGE
}

@export var type : BrickType = BrickType.BRICK1
@export var bonus : BrickBonus = BrickBonus.NONE

const destroy_scene = preload("res://scenes/brick_destroy.tscn")

func _ready() -> void:
	match type:
		BrickType.BRICK1:
			$Mesh["surface_material_override/0"] = load("res://materials/brick1.tres")
		BrickType.BRICK2:
			$Mesh["surface_material_override/0"] = load("res://materials/sandstone_brick.tres")
		BrickType.BRICK3:
			$Mesh["surface_material_override/0"] = load("res://materials/dark_brick.tres")
	$Decal.visible = true
	match bonus:
		BrickBonus.NONE:
			$Decal.visible = false
		BrickBonus.SPEED:
			$Decal.texture_albedo = load("res://textures/decals/speed_icon.png")
			$Decal.modulate = GameManager.SPEED_COLOR
		BrickBonus.SLOW:
			$Decal.texture_albedo = load("res://textures/decals/slow_icon.png")
			$Decal.modulate = GameManager.SLOW_COLOR
		BrickBonus.CHARGE:
			$Decal.texture_albedo = load("res://textures/decals/charge_icon.png")
			$Decal.modulate = GameManager.CHARGE_COLOR

func destroy():
	GameManager.add_points()
	var bricks = get_tree().get_nodes_in_group("Brick")
	if len(bricks) == 1:
		GameManager.emit_signal("level_finished")
	var destroy_node = destroy_scene.instantiate()
	destroy_node.brick_material = $Mesh["surface_material_override/0"]
	GameManager.level_node.add_child(destroy_node)
	destroy_node.global_position = self.global_position
	GameManager.ui.emit_signal("brick_destroyed", self.global_position, bonus)
	queue_free()
