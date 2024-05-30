package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"


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
		recipe.ingredients[i].item = (auto_cast rl.GetRandomValue(1,1))
	}

    return recipe
}
