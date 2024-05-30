package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

World :: struct {
	main_camera: rl.Camera3D,
	player:      Player,
	entities:    [dynamic]Entity,
}

init_world :: proc(w: ^World) {
	w.main_camera = rl.Camera3D {
		up         = {0, 1, 0},
		position   = {0, 1, 0},
		target     = {0, 1, 0.5},
		fovy       = 80,
		projection = .PERSPECTIVE,
	}

	when ODIN_DEBUG {
		append(&w.entities, make_entity_test())
	}
}

update_world :: proc(w: ^World, dt: f32) {
	update_player_movement(&w.player, dt)
	update_main_camera(w)
	update_entity_targetting(w)
}

draw_world :: proc(w: ^World, dt: f32) {
	when ODIN_DEBUG {
		for &e in w.entities {
			entity_draw_debug(&e)
		}
	}
}

update_main_camera :: proc(w: ^World) {
	c := &w.main_camera
	p := &w.player

	c.position = p.position + rl.Vector3{0, 1, 0}
	c.target = c.position + player_get_forward(p)
}

update_entity_targetting :: proc(w: ^World) {
	p := &w.player
	ray := rl.Ray {
		position  = w.main_camera.position,
		direction = player_get_forward(p),
	}
	for &e in w.entities {
		e.targeted = false
		hit := rl.GetRayCollisionBox(ray, entity_get_bounds(&e))
		if hit.hit {
			e.targeted = true
		}
	}
}
