FurnitureRecipe = new Recipe

// @param {map} class Furniture prototype.
// @returns {FurnitureRecipe}
FurnitureRecipe.make = function(class)
    super.make((new FurnitureItem).make(class.make))
    self.class = class
    return self
end function

// @param {Player} player
FurnitureRecipe.craft = function(player)
    player.inventory.insert(0, (new FurnitureItem).make(self.class.make))
end function

return FurnitureRecipe
