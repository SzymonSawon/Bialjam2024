package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

World :: struct {
	now:              f32,
	assets:           Assets,
	main_camera:      rl.Camera3D,
	hud_camera:       rl.Camera3D,
	last_screen_size: rl.Vector2,
	world_layer:      rl.RenderTexture,
	hud_layer:        rl.RenderTexture,
	player:           Player,
	entities:         [dynamic]Entity,
	targetted_entity: ^Entity,
}

init_world :: proc(w: ^World) {
	init_assets(&w.assets)

	w.main_camera = rl.Camera3D {
		up         = {0, 1, 0},
		position   = {0, 1, 0},
		target     = {0, 1, 1},
		fovy       = 80,
		projection = .PERSPECTIVE,
	}

	w.hud_camera = rl.Camera3D {
		up         = {0, 1, 0},
		position   = {0, 0, 0},
		target     = {0, 0, 1},
		fovy       = 80,
		projection = .PERSPECTIVE,
	}

	init_player(&w.player)

	append(&w.entities, make_entity_tentacle())

	when ODIN_DEBUG {
		append(&w.entities, make_entity_test())
	}
}

deinit_world :: proc(w: ^World) {
	deinit_assets(&w.assets)
	delete(w.entities)
}

update_world :: proc(w: ^World, dt: f32) {
    w.now += dt
	update_player_movement(&w.player, dt)
	update_main_camera(w)
	update_entity_targetting(w)
	update_entity_interaction(w)
}

draw_world :: proc(w: ^World, dt: f32) {
	rl.BeginMode3D(w.main_camera)
	defer rl.EndMode3D()

	rl.ClearBackground(BACKGROUND)
	rl.DrawGrid(10, 1)

	rl.DrawModel(w.assets.foodtruck_model, {0, 0, 0}, 1, rl.RAYWHITE)

	for &e in w.entities {
		draw_entity(w, &e)
	}

	when ODIN_DEBUG {
		for &e in w.entities {
			entity_draw_debug(&e)
		}
	}
}

update_render_textures :: proc(w: ^World) {
	screen_size := rl.Vector2{auto_cast rl.GetScreenWidth(), auto_cast rl.GetScreenHeight()}
	if screen_size != w.last_screen_size {
		w.last_screen_size = screen_size
		rl.UnloadRenderTexture(w.world_layer)
		rl.UnloadRenderTexture(w.hud_layer)
		w.world_layer = rl.LoadRenderTexture(
			auto_cast screen_size.x / PIXELIZE,
			auto_cast screen_size.y / PIXELIZE,
		)
		w.hud_layer = rl.LoadRenderTexture(
			auto_cast screen_size.x / PIXELIZE,
			auto_cast screen_size.y / PIXELIZE,
		)
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
	w.targetted_entity = nil
	closest_distance: f32 = 0
	for &e in w.entities {
		e.targeted = false
		hit := rl.GetRayCollisionBox(ray, entity_get_bounds(&e))
		if hit.hit {
			e.targeted = true
			if w.targetted_entity == nil || closest_distance > hit.distance {
				w.targetted_entity = &e
				closest_distance = hit.distance
			}
		}
	}
}

update_entity_interaction :: proc(w: ^World) {
	if (rl.IsMouseButtonPressed(.LEFT) && w.targetted_entity != nil) {
		entity_interact(w, w.targetted_entity)
	}
}
