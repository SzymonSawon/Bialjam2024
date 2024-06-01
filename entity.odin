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
	SHROOM_BOX,
	MAYO_JAR,
	EYE_BOWL,
	GRAV_STABILIZER,
	MATTER_STABILIZER,
    TV,
	BOBER,
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
		recipe_try_wrap_rollo(w, &w.current_recipe, w.player.held_item)
	case .FRIDGE:
		player_hold_item(&w.player, w, .UNICORN_BONES)
	case .LIZARD_HAND:
		player_hold_item(&w.player, w, .CHINESE_SCALE)
	case .CONTRUCTION_SITE:
		recipe_try_add_ingredient(w, &w.current_recipe, w.player.held_item)
        if recipe_is_done(&w.current_recipe){
            player_hold_item(&w.player, w, .ROLLO)
        }
        else{
            player_hold_item(&w.player, w, .NONE)
        }   
	case .SHROOM_BOX:
		player_hold_item(&w.player, w, .MUSHROOMS)
	case .MAYO_JAR:
		player_hold_item(&w.player, w, .VOID_MAYO)
	case .EYE_BOWL:
		player_hold_item(&w.player, w, .EYE_OF_CTHULU)
	case .GRAV_STABILIZER:
        w.grav_stabilty = math.min(30.0 - f32(w.round_number), 12)
	case .MATTER_STABILIZER:
        w.matter_stability = math.min(40.0 - f32(w.round_number), 20)
	case .TV:
		w.grav_stabilty = 30
	case .BOBER:
        w.score += 25
        w.bober_arrives_time = w.now + auto_cast rl.GetRandomValue(6, 9)
        rl.PlaySound(w.assets.bober_catch_sound)
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
		if w.round_number > 0 && !w.slime_has_awakened && w.now - w.start_round_time < 2 {
			draw_puff(w, e.position + {0, 0, 0}, 2, .9001)
		}
		rl.DrawModelEx(
			w.assets.slime_model,
			e.position + {0, 0.2 + change_offset, -0.1 - change_offset},
			{1, 0, 0},
			0,
			{1, 1, 1},
			rl.WHITE,
		)
		rl.DrawModel(
			w.assets.plane_model,
			e.position + {0.3, 0.2 + change_offset, -0.42 - change_offset},
			1,
			rl.WHITE,
		)
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
			w.assets.lizard_hand_model,
			e.position + {0, 0, -0.4},
			{0, 1, 0},
			-90,
			{1, 1, 1},
			rl.WHITE,
		)
	case .SHROOM_BOX:
		rl.DrawModelEx(
			w.assets.shroombox_model,
			e.position + {0, 0, 0.1},
			{0, 0, 1},
			-45,
			{1, 1, 1},
			rl.WHITE,
		)

	case .MAYO_JAR:
		rl.DrawModelEx(
			w.assets.mayo_model,
			e.position + {0, 0, 0},
			{0, 0, 1},
			0,
			{1, 1, 1},
			rl.WHITE,
		)

	case .EYE_BOWL:
		rl.DrawModelEx(
			w.assets.bowl_model,
			e.position + {0, 0, 0},
			{0, 0, 1},
			0,
			{1, 1, 1},
			rl.WHITE,
		)
    case .TV:
		rl.DrawModelEx(
			w.assets.tv_model,
			e.position + {0, 0, 0},
			{0, 0, 1},
			0,
			{1, 1, 1},
			rl.WHITE,
		)
	case .CONTRUCTION_SITE:
		if w.slime_has_awakened && !recipe_is_done(&w.current_recipe){
			rl.DrawModelEx(
				w.assets.wrap_model,
				e.position + {0, -0.13, 0},
				{0, 0, 1},
				0,
				{1, 1, 1},
				rl.WHITE,
			)
		}

		if w.round_number > 0 && w.now - w.start_round_time < 2 {
			draw_puff(w, e.position, 2, .2324)
		}
        if !recipe_is_done(&w.current_recipe){
            for it, ind in w.current_recipe.ingredients {
                if !it.done {
                    continue
                }
                angle_off: rl.Vector3 =
                    {
                        math.cos_f32(f32(ind) * 2.0 * rl.PI / 7.0),
                        0,
                        math.sin_f32(f32(ind) * 2.0 * rl.PI / 7.0),
                    } *
                    0.1
                item_model := item_get_model(w, it.item)
                rl.DrawModelEx(item_model, e.position + angle_off, {0, 0, 1}, 0, {1, 1, 1}, rl.WHITE)
            }
        }
	case .GRAV_STABILIZER:
		scale: f32 = 1
		if w.grav_stabilty < 0 {
			scale = math.pow(math.sin(w.now * 3), 2) * 1 + 1
		}
		rl.DrawModelEx(
			w.assets.button_model,
			e.position + {0, 0, 0},
			{1, 0, 0},
			90,
			{1, 1, 1} * scale,
			rl.WHITE,
		)
	case .MATTER_STABILIZER:
		scale: f32 = 1
		if w.matter_stability < 0 {
			scale = math.pow(math.sin(w.now * 3), 2) * 1 + 1
		}
		rl.DrawModelEx(
			w.assets.button_model,
			e.position + {0, 0, 0},
			{1, 0, 0},
			90,
			{1, 1, 1} * scale,
			rl.WHITE,
		)
	case .BOBER:
        v := w.player.position - e.position
        a := math.atan2(v.x, v.z)
		rl.DrawModelEx(
			w.assets.bober_model,
			e.position + {0, 0, 0},
			{0, 1, 0},
			a * rl.RAD2DEG,
			{1, 1, 1},
			rl.WHITE,
		)
	}
}

make_entity_test :: proc() -> Entity {
	return Entity{kind = .TEST, position = {0, 0.5, 5}, size = {1, 1, 1}}
}

make_entity_tentacle :: proc() -> Entity {
	return Entity{kind = .TENTACLE, position = {0.7, 1, -0.35}, size = {0.2, 0.8, 0.2}}
}

make_entity_slime :: proc() -> Entity {
	return Entity{kind = .SLIME, position = {0.6, 0.8, 1.2}, size = {0.7, 0.8, 0.2}}
}

make_entity_fridge :: proc() -> Entity {
	return Entity{kind = .FRIDGE, position = {1.045, 0.5, -0.1}, size = {0.4, 0.2, 1}}
}

make_entity_lizard_hand :: proc() -> Entity {
	return Entity{kind = .LIZARD_HAND, position = {-0.5, 0.5, -0.4}, size = {0.2, 0.2, 0.5}}
}

make_entity_shroom_box :: proc() -> Entity {
	return Entity{kind = .SHROOM_BOX, position = {-1.15, 0.95, 0.1}, size = {0.2, 0.2, 0.5}}
}

make_entity_mayo_jar :: proc() -> Entity {
	return Entity{kind = .MAYO_JAR, position = {-0.9, 0.75, 0.5}, size = {0.2, 0.2, 0.2}}
}

make_entity_eye_bowl :: proc() -> Entity {
	return Entity{kind = .EYE_BOWL, position = {-0.6, 0.75, 0.45}, size = {0.2, 0.2, 0.2}}
}

make_entity_construction_site :: proc() -> Entity {
	return Entity{kind = .CONTRUCTION_SITE, position = {0, 0.7, 0.4}, size = {0.5, 0.2, 0.5}}
}


make_entity_tv :: proc() -> Entity {
	return Entity{kind = .TV, position = {0, 0.7, 0.4}, size = {0.5, 0.2, 0.5}}
}

make_entity_grav_stabilizer :: proc() -> Entity {
	return Entity{kind = .GRAV_STABILIZER, position = {-0.7, 0.8, -0.65}, size = {0.2, 0.2, 0.1}}
}

make_entity_matter_stabilizer :: proc() -> Entity {
	return Entity{kind = .MATTER_STABILIZER, position = {0.3, 0.8, -0.65}, size = {0.2, 0.2, 0.1}}
}

make_entity_bober :: proc() -> Entity {
	return Entity{kind = .BOBER, position = {0, 5, 0}, size = {0.4, 0.4, 0.4}}
}

