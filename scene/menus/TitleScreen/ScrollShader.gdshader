shader_type canvas_item;

instance uniform float speed_x = 0.1;
instance uniform float speed_y = 0.1;

void vertex() {
	UV.x += TIME * speed_x;
	UV.y += TIME * speed_y;
}