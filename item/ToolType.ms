ToolType = {}

ToolType.shovel = (new ToolType).init("Shvl", 0)
ToolType.hoe = (new ToolType).init("Hoe", 1)
ToolType.sword = (new ToolType).init("Swrd", 2)
ToolType.pickaxe = (new ToolType).init("Pick", 3)
ToolType.axe = (new ToolType).init("Axe", 4)

// @param {string} name
// @param {int} sprite
// @returns {ToolType}
ToolType.init = function(name, sprite)
    self.name = name
    self.sprite = sprite
end function

return ToolType
