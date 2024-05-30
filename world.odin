package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

World :: struct {
	main_camera: rl.Camera3D,
	player:      Player,
}

init_world :: proc(w: ^World) {
	w.main_camera = rl.Camera3D {
		up         = {0, 1, 0},
		position   = {0, 1, 0},
		target     = {0, 1, 0.5},
		fovy       = 80,
		projection = .PERSPECTIVE,
	}
}

update_world :: proc(w: ^World, dt: f32) {
	update_player_movement(&w.player, dt)
	update_main_camera(w)
}

update_main_camera :: proc(w: ^World) {
	c := &w.main_camera
	p := &w.player
    
	c.position = p.position + rl.Vector3{0, 1, 0}
	c.target = c.position + player_get_forward(p)
}
