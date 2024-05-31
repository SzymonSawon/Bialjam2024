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
	recipe_layer:     rl.RenderTexture,
	player:           Player,
	entities:         [dynamic]Entity,
	targetted_entity: ^Entity,
	current_recipe:   Recipe,
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
	append(&w.entities, make_entity_slime())
	append(&w.entities, make_entity_fridge())
	append(&w.entities, make_entity_construction_site())

	when ODIN_DEBUG {
		append(&w.entities, make_entity_test())
	}

	w.recipe_layer = rl.LoadRenderTexture(RECIPE_LAYER_SIZE, RECIPE_LAYER_SIZE)
	w.assets.plane_model.materials[1].maps[0].texture = w.recipe_layer.texture

	w.current_recipe = make_recipe()

	rl.PlayMusicStream(w.assets.radio_music)
}

deinit_world :: proc(w: ^World) {
	deinit_assets(&w.assets)
	rl.UnloadRenderTexture(w.recipe_layer)
	delete(w.entities)
}

update_world :: proc(w: ^World, dt: f32) {
	w.now += dt
	update_player_movement(&w.player, dt)
	update_main_camera(w)
	update_entity_targetting(w)
	update_entity_interaction(w)
	update_music(w)
	update_shaders(w)
}

update_shaders :: proc(w: ^World) {
	rl.SetShaderValue(
		w.assets.hori_wobble_diffuse_shader,
		rl.GetShaderLocation(w.assets.hori_wobble_diffuse_shader, "time"),
		&w.now,
		.FLOAT,
	)
	rl.SetShaderValue(
		w.assets.generic_diffuse_shader,
		rl.GetShaderLocation(w.assets.generic_diffuse_shader, "time"),
		&w.now,
		.FLOAT,
	)
	{
		targetingFactor: f32 = 0
		rl.SetShaderValue(
			w.assets.generic_diffuse_shader,
			rl.GetShaderLocation(w.assets.generic_diffuse_shader, "targetingFactor"),
			&targetingFactor,
			.FLOAT,
		)
	}
}

update_music :: proc(w: ^World) {
	rl.UpdateMusicStream(w.assets.radio_music)
}

draw_world :: proc(w: ^World, dt: f32) {
	rl.BeginMode3D(w.main_camera)
	defer rl.EndMode3D()

	rl.ClearBackground(BACKGROUND)
	when ODIN_DEBUG {
		rl.DrawGrid(10, 1)
	}

	rl.DrawModel(w.assets.foodtruck_model, {0, 0, 0}, 1, rl.WHITE)

	// TODO: move to kelner
	rl.DrawModel(w.assets.plane_model, {0.8, 0.9, 0.9}, 1, rl.WHITE)

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
