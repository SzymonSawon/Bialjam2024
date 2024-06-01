package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

SceneKind :: enum {
	GAME_OVER,
	MENU,
	GAMEPLAY,
}

World :: struct {
	now:                 f32,
	assets:              Assets,
	main_camera:         rl.Camera3D,
	hud_camera:          rl.Camera3D,
	last_screen_size:    rl.Vector2,
	world_layer:         rl.RenderTexture,
	hud_layer:           rl.RenderTexture,
	recipe_layer:        rl.RenderTexture,
	player:              Player,
	entities:            [dynamic]Entity,
	targetted_entity:    ^Entity,
	current_recipe:      Recipe,
	come_to_window_time: f32,
	slime_has_awakened:  bool,
	round_number:        int,
	cursor_radius:       f32,
	cursor_radius_t:     f32,
	current_round_time:  f32,
	start_round_time:    f32,
	max_round_time:      f32,
	score:               f32,
	sk:                  SceneKind,
	should_quit:         bool,
	grav_stabilty:       f32,
	bober_arrives_time:  f32,
	is_wrap_wrapped:     bool,
	count_rollos:        int,
}

init_world :: proc(w: ^World) {
	w.now = 0
	w.should_quit = false

	init_assets(&w.assets)

	when ODIN_DEBUG {
		w.sk = .GAMEPLAY
		rl.DisableCursor()
	} else {
		w.sk = .MENU
	}

	#partial switch w.sk {
	case .GAME_OVER:
		fallthrough
	case .GAMEPLAY:
		w.main_camera = rl.Camera3D {
			up         = {0, 1, 0},
			position   = {0, 1, 0},
			target     = {1, 1, 0},
			fovy       = 80,
			projection = .PERSPECTIVE,
		}
	case .MENU:
		w.main_camera = rl.Camera3D {
			up         = {0, 1, 0},
			position   = {2, 4, 6},
			target     = {-0.2, -.2, -1},
			fovy       = 80,
			projection = .PERSPECTIVE,
		}
	}

	w.hud_camera = rl.Camera3D {
		up         = {0, 1, 0},
		position   = {0, 0, 0},
		target     = {0, 0, 1},
		fovy       = 80,
		projection = .PERSPECTIVE,
	}

	init_player(&w.player)

	w.targetted_entity = nil

	append(&w.entities, make_entity_tentacle())
	append(&w.entities, make_entity_slime())
	append(&w.entities, make_entity_fridge())
	append(&w.entities, make_entity_lizard_hand())
	append(&w.entities, make_entity_shroom_box())
	append(&w.entities, make_entity_mayo_jar())
	append(&w.entities, make_entity_eye_bowl())
	append(&w.entities, make_entity_construction_site())
	append(&w.entities, make_entity_grav_stabilizer())
	append(&w.entities, make_entity_bober())

	when ODIN_DEBUG {
		append(&w.entities, make_entity_test())
	}

	w.recipe_layer = rl.LoadRenderTexture(RECIPE_LAYER_SIZE, RECIPE_LAYER_SIZE)
	w.assets.plane_model.materials[1].maps[0].texture = w.recipe_layer.texture

	w.slime_has_awakened = false
	w.max_round_time = 15
	w.current_recipe = make_recipe(w)
	w.come_to_window_time = w.now + 5
	w.last_screen_size = {0, 0}
	w.score = 0
	w.round_number = 0
	w.start_round_time = 0
	w.grav_stabilty = -1 // 30
	w.bober_arrives_time = w.now + 20
	w.current_round_time = 0
	rl.PlayMusicStream(w.assets.radio_music)
	w.current_recipe = make_recipe(w)
	w.count_rollos = 0
	w.is_wrap_wrapped = false

}

deinit_world :: proc(w: ^World) {
	deinit_assets(&w.assets)
	rl.UnloadRenderTexture(w.recipe_layer)
	rl.UnloadRenderTexture(w.hud_layer)
	rl.UnloadRenderTexture(w.world_layer)
	clear(&w.entities)
}

update_world :: proc(w: ^World, dt: f32) {
	w.now += dt
	if w.round_number > 1 &&
	   (w.now - w.start_round_time >= w.max_round_time || w.grav_stabilty < -6) {
		world_set_scene(w, .GAME_OVER)
	}
	if w.come_to_window_time <= w.now && !w.slime_has_awakened {
		w.slime_has_awakened = true
		rl.PlaySound(w.assets.ding_sound)
		w.round_number += 1
		w.start_round_time = w.now
		w.count_rollos += 1
        w.is_wrap_wrapped = false
	}
	if w.is_wrap_wrapped && w.count_rollos == 1{
		w.come_to_window_time = w.now + 5
		w.count_rollos = 0
		w.slime_has_awakened = false
		w.current_recipe = make_recipe(w)
		if w.max_round_time > 6 {
			w.max_round_time -= 0.5
		}
		w.score +=
			f32(w.current_recipe.ingredients_count) *
			math.max(0, (w.max_round_time - (w.now - w.start_round_time)))
		w.start_round_time = w.now
		w.is_wrap_wrapped = true
	}
	if w.round_number > 1 {
		w.grav_stabilty -= dt
	} else {
		w.bober_arrives_time = w.now + 3
	}
	update_player_movement(&w.player, dt)
	update_bober(w, dt)
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
	rl.SetShaderValue(
		w.assets.skycube_shader,
		rl.GetShaderLocation(w.assets.skycube_shader, "time"),
		&w.now,
		.FLOAT,
	)
	rl.SetShaderValue(
		w.assets.postprocess_shader,
		rl.GetShaderLocation(w.assets.postprocess_shader, "time"),
		&w.now,
		.FLOAT,
	)
	{
		shakiness: f32 = 0
		if w.grav_stabilty < 0 {
			shakiness = 1
		}
		rl.SetShaderValue(
			w.assets.postprocess_shader,
			rl.GetShaderLocation(w.assets.postprocess_shader, "shakiness"),
			&shakiness,
			.FLOAT,
		)
	}
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
	rl.DrawModel(w.assets.świetlówka_model, {0, 1.25, 0}, 0.3, rl.WHITE)
	rl.DrawModel(w.assets.skycube_model, {0, 0, 0}, 30, rl.WHITE)

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
	when ODIN_OS == .Darwin {
		screen_size := rl.Vector2{auto_cast rl.GetScreenWidth(), auto_cast rl.GetScreenHeight()}
	} else {
		screen_size := rl.Vector2{auto_cast rl.GetRenderWidth(), auto_cast rl.GetRenderHeight()}
	}
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
		if hit.hit && hit.distance < MAX_REACH {
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

world_set_scene :: proc(w: ^World, sk: SceneKind) {
	w.sk = sk
	if sk == .GAMEPLAY {
		rl.DisableCursor()
	} else {
		rl.EnableCursor()
	}
}

world_reload :: proc(w: ^World) {
	deinit_world(w)
	init_world(w)
}
