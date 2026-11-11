extends Area2D

var art_visible := true


func set_art_visible(visible: bool) -> void:
	art_visible = visible
	queue_redraw()


func _ready() -> void:
	z_index = 2
	collision_layer = 0
	collision_mask = 1
	monitoring = true
	var hitbox := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(52.0, 72.0)
	hitbox.shape = shape
	add_child(hitbox)


func _draw() -> void:
	if not art_visible:
		return
	# A warm wooden gate echoes the dungeon door in the reference image.
	draw_rect(Rect2(-23.0, -35.0, 46.0, 66.0), Color("302a32"))
	draw_rect(Rect2(-19.0, -31.0, 38.0, 62.0), Color("a9573d"))
	draw_rect(Rect2(-14.0, -26.0, 28.0, 57.0), Color("d98752"))
	draw_rect(Rect2(-9.0, -22.0, 18.0, 53.0), Color("9b4b38"))
	draw_rect(Rect2(-4.0, -19.0, 3.0, 49.0), Color("e9b765"))
	draw_circle(Vector2(7.0, 1.0), 2.5, Color("ffe28a"))
	draw_rect(Rect2(-27.0, -39.0, 54.0, 6.0), Color("efbf68"))
	draw_rect(Rect2(-24.0, -44.0, 48.0, 5.0), Color("e99650"))
