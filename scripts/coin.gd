extends Area2D

const COIN_TEXTURE: Texture2D = preload("res://assets/four_seasons/objects_/coin_.png")

var animation_time := 0.0
var frame := 0
var resting_y := 0.0
var display_scale := 3.0


func setup(scale_factor: float) -> void:
	display_scale = scale_factor


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	monitoring = true
	add_to_group("coins")
	var hitbox := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 8.0 * display_scale
	hitbox.shape = circle
	add_child(hitbox)
	var sprite := Sprite2D.new()
	sprite.name = "Sprite2D"
	sprite.texture = COIN_TEXTURE
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0.0, 0.0, 16.0, 16.0)
	sprite.scale = Vector2(display_scale, display_scale)
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)
	resting_y = position.y


func _process(delta: float) -> void:
	animation_time += delta
	if animation_time >= 0.085:
		animation_time = 0.0
		frame = (frame + 1) % 12
		$Sprite2D.region_rect = Rect2(float(frame * 16), 0.0, 16.0, 16.0)
	position.y = resting_y + sin(Time.get_ticks_msec() * 0.004) * 3.0
