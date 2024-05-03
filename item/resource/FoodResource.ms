FoodResource = new Resource

// @param {string} name
// @param {int} sprite
// @param {int} color
// @param {int} heal
// @param {int} staminaCost
// @return {FoodResouce}
FoodResource.make = function(name, sprite, color, heal, staminaCost)
    super.make(name, sprite, color)
    self.heal = heal
    self.staminaCost = staminaCost
    return self
end function

// @param {Tile} tile
// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
FoodResource.interactOn = function(tile, level, xt, yt, player, attackDir)
    if player.health < player.maxHealth and player.payStamina(staminaCost) then
        player.heal(heal)
        return true
    end if
    return false
end function

return FoodResource
