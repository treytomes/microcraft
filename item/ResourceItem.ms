ResourceItem = new Item
ResourceItem._class = "ResourceItem"

// @param {Resource} resource
// @returns {ResourceItem}
ResourceItem.init = function(resource, count = 1)
    self.resource = resource
    self.count = count
    return self
end function

// @returns {int}
ResourceItem.getColor = function()
    return self.resource.color
end function

// @returns {int}
ResourceItem.getSprite = function()
    return self.resource.sprite
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
ResourceItem.renderIcon = function(screen, x, y)
    screen.render(x, y, self.resource.sprite, self.resource.color, 0)
end function

// @param {Screen} screen
// @param {int} x
// @param {int} y
ResourceItem.renderInventory = function(screen, x, y)
    screen.render(x, y, self.resource.sprite, self.resource.color, 0)
    Font.draw(self.resource.name, screen, x + 32, y, Color.get(-1, 555, 555, 555))
    cc = self.count
    if cc > 999 then cc = 999
    Font.draw("" + cc, screen, x + 8, y, Color.get(-1, 444, 444, 444))
end function

// @returns {string}
ResourceItem.getName = function()
    return self.resource.name
end function

// @param {ItemEntity} itemEntity
ResourceItem.onTake = function(itemEntity)
end function

// @param {Tile} tile
// @param {Level} level
// @param {int} xt
// @param {int} yt
// @param {Player} player
// @param {int} attackDir
// @returns {boolean}
ResourceItem.interactOn(tile, level, xt, yt, player, attackDir)
    if self.resource.interactOn(tile, level, xt, yt, player, attackDir) then
        count -= 1
        return true
    end if
    return false
end function

// @returns {boolean}
ResourceItem.isDepleted = function()
    return count <= 0;
end function

return ResourceItem
