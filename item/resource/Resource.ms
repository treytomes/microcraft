Resource = {}

// @param {string} name
// @param {int} sprite
// @param {int} color
// @returns {Resource}
Resource.make = function(name, sprite, color)
    qa.assert(name.len <= 6, "Name cannot be longer than six characters!")
    self.name = name
    self.sprite = sprite
    self.color = color
end function

// @param {Tile} tile
// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
Resource.interactOn = function(tile, level, xt, yt, player, attackDir)
    return false
end function

return Resource
