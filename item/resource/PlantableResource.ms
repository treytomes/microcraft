PlantableResource = new Resource

// @param {string} name
// @param {int} sprite
// @param {int} color
// @param {Tile} targetTile
// @param {Tile[]} sourceTiles
PlantableResource.make = function(name, sprite, color, targetTile, sourceTiles)
    super.make(name, sprite, color)
    self.sourceTiles = sourceTiles
    self.targetTile = targetTile
end function

// @param {Tile} tile
// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
PlantableResource.interactOn = function(tile, level, xt, yt, player, attackDir)
    if self.sourceTiles.contains(tile) then
        level.setTile(xt, yt, self.targetTile, 0)
        return true
    end if
    return false
end function

return PlantableResource
