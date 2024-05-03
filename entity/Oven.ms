Oven = new Furniture

// @returns {Oven}
Oven.make = function()
    super.make("Oven")
    self.col = Color.get(-1, 000, 332, 442)
    self.sprite = 2
    self.xr = 3
    self.yr = 2
    return self
end function

// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Oven.use = function(player, attackDir)
    player.game.setMenu((new CraftingMenu).make(Crafting.ovenRecipes, player))
    return true
end function

return Oven
