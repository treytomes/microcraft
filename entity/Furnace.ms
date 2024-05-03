Furnace = new Furniture

// @returns {Furnace}
Furnace.make = function()
    super.make("Furnace")
    self.col = Color.get(-1, 000, 222, 333)
    self.sprite = 3
    self.xr = 3
    self.yr = 2
    return self
end function

// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Furnace.use = function(player, attackDir)
    player.game.setMenu((new CraftingMenu).make(Crafting.furnaceRecipes, player))
    return true
end function

return Furnace
