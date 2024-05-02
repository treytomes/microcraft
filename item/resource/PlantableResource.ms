PlantableResource = new Resource

// @param {string} name
// @param {int} sprite
// @param {int} color
// @param {Tile} targetTile
// @param {Tile[]} sourceTiles
PlantableResource.init = function(name, sprite, color, targetTile, sourceTiles)
    super.init(name, sprite, color)
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
PlantableResource.interactOn = function(Tile tile, Level level, int xt, int yt, Player player, int attackDir) {
    if self.sourceTiles.contains(tile) then
        level.setTile(xt, yt, targetTile, 0)
        return true
    end if
    return false
end function

return PlantableResource
