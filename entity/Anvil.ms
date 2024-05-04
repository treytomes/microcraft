Anvil = new Furniture

Anvil.make = function()
    super.make("Anvil")
    self.col = Color.get(-1, 000, 111, 222)
    self.sprite = 0
    self.xr = 3
    self.yr = 2
    return self
end function

// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Anvil.use = function(player, attackDir)
    player.game.setMenu((new CraftingMenu).make(Crafting.anvilRecipes, player))
    return true
end function

return Anvil
