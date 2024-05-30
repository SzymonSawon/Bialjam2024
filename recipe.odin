package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

RECIPE_COLOR :: rl.RAYWHITE
RECIPE_LAYER_SIZE :: 640


Recipe :: struct {
	ingredients:       [10]struct {
		item: Item,
		done: bool,
	},
	ingredients_count: int,
}


make_recipe :: proc() -> Recipe {
	recipe := Recipe{}
	recipe.ingredients_count = auto_cast rl.GetRandomValue(1, 5)
	for i := 0; i <= recipe.ingredients_count; i += 1 {
		recipe.ingredients[i].item = (auto_cast rl.GetRandomValue(1, 6))
	}

	return recipe
}

draw_recipe_layer :: proc(w: ^World) {
	c := rl.Camera3D {
		position   = {0, 0, 0},
		target     = {0, 0, 1},
		up         = {0, 1, 0},
		fovy       = 3,
		projection = .ORTHOGRAPHIC,
	}

	rl.ClearBackground(RECIPE_COLOR)

	{
		rl.BeginMode3D(c)
		defer rl.EndMode3D()

		for i, ind in w.current_recipe.ingredients[0:w.current_recipe.ingredients_count] {
			model := item_get_model(w, i.item)
			rl.DrawModelEx(model, {1.25, 1.1 - 0.35 * auto_cast ind, 1}, {1, 0, 0}, -30, {2, 2, 2}, rl.WHITE)
		}
	}

	{
		for i, ind in w.current_recipe.ingredients[0:w.current_recipe.ingredients_count] {
			rl.DrawText(rl.TextFormat("%s", item_get_name(i.item)), 120, 40 + auto_cast (ind * RECIPE_LAYER_SIZE / 8), RECIPE_LAYER_SIZE / 8, rl.BLACK)
            if i.done {
                rl.DrawLineEx({120, auto_cast (40 + ind * RECIPE_LAYER_SIZE / 8) + RECIPE_LAYER_SIZE / 16}, {RECIPE_LAYER_SIZE - 40, auto_cast (40 + ind * RECIPE_LAYER_SIZE / 8) + RECIPE_LAYER_SIZE / 16},8, rl.RED)
            }
		}
	}
}

recipe_try_add_ingredient :: proc(r: ^Recipe, it: Item) {
    for &i in r.ingredients[0:r.ingredients_count] {
        if i.item == it && !i.done {
            i.done = true 
            // TODO: play good sound
            return
        }
    }
    // TODO: play sad sound
}

recipe_is_done :: proc(r: ^Recipe) -> bool {
    for &i in r.ingredients[0:r.ingredients_count] {
        if !i.done {
            return false
        }
    }
    return true
}
