FurnitureItem = new Item
FurnitureItem._class = "FurnitureItem"

// @param {Furniture} furniture
// @returns {FurnitureItem}
FurnitureItem.make = function(furniture)
    self.furniture = furniture
    self.placed = false
    return self
end function

// @returns {int}
FurnitureItem.getColor = function()
    return self.furniture.col
end function

// @returns {int}
FurnitureItem.getSprite = function()
    return self.furniture.sprite + 10 * 32
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
FurnitureItem.renderIcon = function(screen, x, y)
    screen.render(x, y, self.getSprite(), self.getColor(), 0)
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
FurnitureItem.renderInventory = function(screen, x, y)
    screen.render(x, y, self.getSprite(), self.getColor(), 0)
    Font.draw(self.furniture.name, screen, x + 8, y, Color.get(-1, 555, 555, 555))
end function

// @param {ItemEntity} itemEntity
FurnitureItem.onTake = function(itemEntity)
end function

// @returns {boolean}
FurnitureItem.canAttack = function()
    return false
end function

// @param {Tile} tile
// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
FurnitureItem.interactOn = function(tile, level, xt, yt, player, attackDir)
    if tile.mayPass(level, xt, yt, self.furniture) then
        self.furniture.x = xt * 16 + 8
        self.furniture.y = yt * 16 + 8
        level.push(self.furniture)
        self.placed = true
        return true
    end if
    return false
end function

// @returns {boolean}
FurnitureItem.isDepleted = function()
    return placed
end function

// @returns {string}
FurnitureItem.getName = function()
    return furniture.name
end function

return FurnitureItem
