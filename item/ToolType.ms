ToolType = {}

// @param {string} name
// @param {int} sprite
// @returns {ToolType}
ToolType.make = function(name, sprite)
    self.name = name
    self.sprite = sprite
end function

ToolType.shovel = (new ToolType).make("Shvl", 0)
ToolType.hoe = (new ToolType).make("Hoe", 1)
ToolType.sword = (new ToolType).make("Swrd", 2)
ToolType.pickaxe = (new ToolType).make("Pick", 3)
ToolType.axe = (new ToolType).make("Axe", 4)

return ToolType
