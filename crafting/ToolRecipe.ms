ToolRecipe = new Recipe

// @param {ToolType} type
// @param {int} level
// @returns {ToolRecipe}
ToolRecipe.init = function(type, level)
    super.init((new ToolItem(type, level)).init)
    self.type = type
    self.level = level
    return self
end function

// @param {Player} player
ToolRecipe.craft = function(player)
    player.inventory.insert(0, (new ToolItem).init(type, level))
end function

return ToolRecipe
