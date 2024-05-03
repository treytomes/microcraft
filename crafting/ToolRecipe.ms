ToolRecipe = new Recipe

// @param {ToolType} type
// @param {int} level
// @returns {ToolRecipe}
ToolRecipe.make = function(type, level)
    super.make((new ToolItem(type, level)).make)
    self.type = type
    self.level = level
    return self
end function

// @param {Player} player
ToolRecipe.craft = function(player)
    player.inventory.insert(0, (new ToolItem).make(type, level))
end function

return ToolRecipe
