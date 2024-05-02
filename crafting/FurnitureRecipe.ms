FurnitureRecipe = new Recipe

// @param {map} class Furniture prototype.
// @returns {FurnitureRecipe}
FurnitureRecipe.init = function(class)
    super.init((new FurnitureItem).init(class.init))
    self.class = class
    return self
end function

// @param {Player} player
FurnitureRecipe.craft = function(player)
    player.inventory.insert(0, (new FurnitureItem).init(self.class.init))
end function

return FurnitureRecipe
