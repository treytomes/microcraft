Chest = new Furniture

// @returns {Chest}
Chest.make = function()
    super.make("Chest")
    self.col = Color.get(-1, 110, 331, 552)
    self.sprite = 1
end function

// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Chest.use = function(player, attackDir)
    player.game.setMenu((new ContainerMenu).make(player, "Chest", inventory))
    return true
end function

return Chest