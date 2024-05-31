package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

EntityKind :: enum {
	TEST,
	TENTACLE,
	SLIME,
	FRIDGE,
	LIZARD_HAND,
	CONTRUCTION_SITE,
}

Entity :: struct {
	kind:     EntityKind,
	position: rl.Vector3,
	size:     rl.Vector3,
	targeted: bool,
}

entity_get_bounds :: proc(e: ^Entity) -> rl.BoundingBox {
	return rl.BoundingBox{e.position - e.size / 2, e.position + e.size / 2}
}

entity_draw_debug :: proc(e: ^Entity) {
	bb := entity_get_bounds(e)
	if e.targeted {
		rl.DrawBoundingBox(bb, rl.GREEN)
	} else {
		rl.DrawBoundingBox(bb, rl.WHITE)
	}
}

entity_interact :: proc(w: ^World, e: ^Entity) {
	switch e.kind {
	case .TEST:
		fmt.println("Hello, there")
	case .TENTACLE:
		player_hold_item(&w.player, w, .SQUID_MEAT)
	case .SLIME:
	case .FRIDGE:
		player_hold_item(&w.player, w, .UNICORN_BONES)
	case .LIZARD_HAND:
		player_hold_item(&w.player, w, .CHINESE_SCALE)
	case .CONTRUCTION_SITE:
		recipe_try_add_ingredient(w, &w.current_recipe, w.player.held_item)
		player_hold_item(&w.player, w, .NONE)
	}
}

draw_entity :: proc(w: ^World, e: ^Entity) {
	{
		targetingFactor: f32 = 1 if e.targeted else 0
		rl.SetShaderValue(
			w.assets.generic_diffuse_shader,
			rl.GetShaderLocation(w.assets.generic_diffuse_shader, "targetingFactor"),
			&targetingFactor,
			.FLOAT,
		)
		rl.SetShaderValue(
			w.assets.hori_wobble_diffuse_shader,
			rl.GetShaderLocation(w.assets.generic_diffuse_shader, "targetingFactor"),
			&targetingFactor,
			.FLOAT,
		)
	}
	switch e.kind {
	case .TEST:
	case .TENTACLE:
		rl.DrawModelEx(
			w.assets.portal_model,
			e.position + {0, 0.27, 0.0},
			{1, 0, 0},
			0,
			{1, 1, 1},
			rl.WHITE,
		)
		rl.DrawModelEx(
			w.assets.tentacle_model,
			e.position + {0, 0.1, 0.05},
			{1, 0, 0},
			0,
			{1, 1, 1},
			rl.WHITE,
		)
	case .SLIME:
		time_since_change := w.now - w.come_to_window_time
        change_offset := (1 - math.min(1, (time_since_change / 0.2))) * -0.5
        rl.DrawModelEx(
            w.assets.slime_model,
            e.position + {0, 0 + change_offset , 1.5 - change_offset},
            {1, 0, 0},
            0,
            {1, 1, 1},
            rl.WHITE,
        )
        rl.DrawModel(w.assets.plane_model, e.position + {0.3, 0 + change_offset, 1.28 - change_offset}, 1, rl.WHITE)
	case .FRIDGE:
		rl.DrawModelEx(
			w.assets.fridge_model,
			e.position + {0.05, 0.05, -0.02},
			{1, 0, 0},
			0,
			{1, 1, 1},
			rl.WHITE,
		)

		rl.DrawModelEx(
			w.assets.fridge_bones_model,
			e.position + {0, 0, -0.1},
			{1, 0, 0},
			0,
			{1, 1, 1},
			rl.WHITE,
		)
	case .LIZARD_HAND:
		rl.DrawModelEx(
			w.assets.portal_model,
			e.position + {0, 0, -0.3},
			{1, 0, 0},
			-90,
			{1, 1, 1},
			rl.WHITE,
		)
		rl.DrawModelEx(
			w.assets.lizard_hand_model,
			e.position + {0,0,0.1},
			{0, 1, 0},
			-90,
			{1, 1, 1},
			rl.WHITE,
		)

	case .CONTRUCTION_SITE:
	}
}

make_entity_test :: proc() -> Entity {
	return Entity{kind = .TEST, position = {0, 0.5, 5}, size = {1, 1, 1}}
}

make_entity_tentacle :: proc() -> Entity {
	return Entity{kind = .TENTACLE, position = {0.7, 1, -0.35}, size = {0.2, 0.8, 0.2}}
}

make_entity_slime :: proc() -> Entity {
	return Entity{kind = .SLIME, position = {0.7, 1, -0.35}, size = {0.2, 0.8, 0.2}}
}

make_entity_fridge :: proc() -> Entity {
	return Entity{kind = .FRIDGE, position = {1.045, 0.5, -0.1}, size = {0.4, 0.2, 1}}
}

make_entity_lizard_hand :: proc() -> Entity {
	return Entity{kind = .LIZARD_HAND, position = {-0.5, 0.5, -0.4}, size = {0.2, 0.2, 0.3}}
}

make_entity_construction_site :: proc() -> Entity {
	return Entity{kind = .CONTRUCTION_SITE, position = {0, 0.6, 0.5}, size = {0.6, 0.2, 0.6}}
}
