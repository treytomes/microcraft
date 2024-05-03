Crafting = {}

// @type {Recipe[]}
Crafting.anvilRecipes = []

// @type {Recipe[]}
Crafting.ovenRecipes = []

// @type {Recipe[]}
Crafting.furnaceRecipes = []

// @type {Recipe[]}
Crafting.workbenchRecipes = []

Crafting.workbenchRecipes.push((new FurnitureRecipe).make(Lantern).addCost(Resource.wood, 5).addCost(Resource.slime, 10).addCost(Resource.glass, 4))

Crafting.workbenchRecipes.push((new FurnitureRecipe).make(Oven).addCost(Resource.stone, 15))
Crafting.workbenchRecipes.push((new FurnitureRecipe).make(Furnace).addCost(Resource.stone, 20))
Crafting.workbenchRecipes.push((new FurnitureRecipe).make(Workbench).addCost(Resource.wood, 20))
Crafting.workbenchRecipes.push((new FurnitureRecipe).make(Chest).addCost(Resource.wood, 20))
Crafting.workbenchRecipes.push((new FurnitureRecipe).make(Anvil).addCost(Resource.ironIngot, 5))

Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.sword, 0).addCost(Resource.wood, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.axe, 0).addCost(Resource.wood, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.hoe, 0).addCost(Resource.wood, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.pickaxe, 0).addCost(Resource.wood, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.shovel, 0).addCost(Resource.wood, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.sword, 1).addCost(Resource.wood, 5).addCost(Resource.stone, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.axe, 1).addCost(Resource.wood, 5).addCost(Resource.stone, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.hoe, 1).addCost(Resource.wood, 5).addCost(Resource.stone, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.pickaxe, 1).addCost(Resource.wood, 5).addCost(Resource.stone, 5))
Crafting.workbenchRecipes.push((new ToolRecipe).make(ToolType.shovel, 1).addCost(Resource.wood, 5).addCost(Resource.stone, 5))

Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.sword, 2).addCost(Resource.wood, 5).addCost(Resource.ironIngot, 5))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.axe, 2).addCost(Resource.wood, 5).addCost(Resource.ironIngot, 5))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.hoe, 2).addCost(Resource.wood, 5).addCost(Resource.ironIngot, 5))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.pickaxe, 2).addCost(Resource.wood, 5).addCost(Resource.ironIngot, 5))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.shovel, 2).addCost(Resource.wood, 5).addCost(Resource.ironIngot, 5))

Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.sword, 3).addCost(Resource.wood, 5).addCost(Resource.goldIngot, 5))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.axe, 3).addCost(Resource.wood, 5).addCost(Resource.goldIngot, 5))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.hoe, 3).addCost(Resource.wood, 5).addCost(Resource.goldIngot, 5))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.pickaxe, 3).addCost(Resource.wood, 5).addCost(Resource.goldIngot, 5))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.shovel, 3).addCost(Resource.wood, 5).addCost(Resource.goldIngot, 5))

Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.sword, 4).addCost(Resource.wood, 5).addCost(Resource.gem, 50))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.axe, 4).addCost(Resource.wood, 5).addCost(Resource.gem, 50))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.hoe, 4).addCost(Resource.wood, 5).addCost(Resource.gem, 50))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.pickaxe, 4).addCost(Resource.wood, 5).addCost(Resource.gem, 50))
Crafting.anvilRecipes.push((new ToolRecipe).make(ToolType.shovel, 4).addCost(Resource.wood, 5).addCost(Resource.gem, 50))

Crafting.furnaceRecipes.push((new ResourceRecipe).make(Resource.ironIngot).addCost(Resource.ironOre, 4).addCost(Resource.coal, 1))
Crafting.furnaceRecipes.push((new ResourceRecipe).make(Resource.goldIngot).addCost(Resource.goldOre, 4).addCost(Resource.coal, 1))
Crafting.furnaceRecipes.push((new ResourceRecipe).make(Resource.glass).addCost(Resource.sand, 4).addCost(Resource.coal, 1))

Crafting.ovenRecipes.push((new ResourceRecipe).make(Resource.bread).addCost(Resource.wheat, 4))

return Crafting
