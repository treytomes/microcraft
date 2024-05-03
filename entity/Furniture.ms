Furniture = new Entity

// @param {string} name
// @returns {Furniture}
Furniture.make = function(name)
    super.make()

    self.pushTime = 0
    self.pushDir = -1
    self.col = 0
    self.sprite = 0
    self.shouldTake = null

    self.name = name
    self.xr = 3
    self.yr = 3
    return self
end function

Furniture.tick = function()
    if self.shouldTake != null then
        if self.shouldTake.activeItem isa PowerGloveItem then
            self.remove
            self.shouldTake.inventory.insert(0, self.shouldTake.activeItem)
            self.shouldTake.activeItem = (new FurnitureItem).make(self)
        end if
        self.shouldTake = null
    end if
    if self.pushDir == 0 then self.move(0,  1)
    if self.pushDir == 1 then self.move(0, -1)
    if self.pushDir == 2 then self.move(-1, 0)
    if self.pushDir == 3 then self.move( 1, 0)
    self.pushDir = -1
    if self.pushTime > 0 then self.pushTime -= 1;
end function

// @param {Screen} screen
Furniture.render = function(screen)
    screen.render(self.x - 8, self.y - 8 - 4, self.sprite * 2 + 8 * 32, self.col, 0)
    screen.render(self.x - 0, self.y - 8 - 4, self.sprite * 2 + 8 * 32 + 1, self.col, 0)
    screen.render(self.x - 8, self.y - 0 - 4, self.sprite * 2 + 8 * 32 + 32, self.col, 0)
    screen.render(self.x - 0, self.y - 0 - 4, self.sprite * 2 + 8 * 32 + 33, self.col, 0)
end function

// @param {Entity} e
Furniture.blocks = function(e)
    return true
end function

// @param {Entity} entity
Furniture.touchedBy = function(entity)
    if entity isa Player and self.pushTime == 0 then
        self.pushDir = entity.dir
        self.pushTime = 10
    end if
end function

// @param {Player} player
Furniture.take = function(player)
    self.shouldTake = player
end function

return Furniture
