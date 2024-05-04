FlowerTile = new GrassTile

// @param {int} id
// @returns {Tile}
FlowerTile.make = function(id)
    super.make(id)
    Tile.tiles[id] = self
    connectsToGrass = true
end function

// @param {Screen} screen
// @param {Level} level
// @param {int} x
// @param {int} y
FlowerTile.render = function(screen, level, x, y)
    super.render(screen, level, x, y)

    data = level.getData(x, y)
    shape = (data / 16) % 2
    flowerCol = Color.get(10, level.grassColor, 555, 440)

    if shape == 0 then screen.render(x * 16 + 0, y * 16 + 0, 1 + 1 * 32, flowerCol, 0)
    if shape == 1 then screen.render(x * 16 + 8, y * 16 + 0, 1 + 1 * 32, flowerCol, 0)
    if shape == 1 then screen.render(x * 16 + 0, y * 16 + 8, 1 + 1 * 32, flowerCol, 0)
    if shape == 0 then screen.render(x * 16 + 8, y * 16 + 8, 1 + 1 * 32, flowerCol, 0)
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {Item} item
// @param {int} attackDir
// @returns {boolean}
FlowerTile.interact = function(level, xt, yt, player, item, attackDir)
    if item isa ToolItem then
        tool = item
        if tool.type == ToolType.shovel then
            if player.payStamina(4 - tool.level) then
                level.add((new ItemEntity).make((new ResourceItem).make(Resource.flower), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
                level.add((new ItemEntity).make((new ResourceItem).make(Resource.flower), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
                level.setTile(x, y, Tile.grass, 0)
                return true
            end if
        end if
    end if
    return false
end function

// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Mob} source
// @param {int} dmg
// @param {int} attackDir
FlowerTile.hurt = function(level, x, y, source, dmg, attackDir)
    count = Random.nextInt(2) + 1
    for i in range(0, count - 1)
        level.add((new ItemEntity).make((new ResourceItem).make(Resource.flower), x * 16 + Random.nextInt(10) + 3, y * 16 + Random.nextInt(10) + 3))
    end for
    level.setTile(x, y, Tile.grass, 0)
end function

return FlowerTile
