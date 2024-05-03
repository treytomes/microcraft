Workbench = new Furniture

// @returns {Workbench}
Workbench.make = function()
    super.make("Workbench")
    self.col = Color.get(-1, 100, 321, 431)
    self.sprite = 4
    self.xr = 3
    self.yr = 2
    return self
end function

// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Workbench.use = function(player, attackDir)
    player.game.setMenu((new CraftingMenu).make(Crafting.workbenchRecipes, player))
    return true
end function

return Workbench
