InventoryMenu = new Menu

// @param {Player} player
// @returns {self}
InventoryMenu.make = function(player)
    super.make
    self.player = player
    self.selected = 0

    if self.player.activeItem != null then
        self.player.inventory.items.insert(0, self.player.activeItem)
        self.player.activeItem = null
    end if
    return self
end function

InventoryMenu.tick = function()
    if self.input.menu.clicked then self.game.setMenu(null)

    if self.input.up.clicked then self.selected -= 1
    if self.input.down.clicked then self.selected += 1

    len = self.player.inventory.items.len
    if len == 0 then self.selected = 0
    if self.selected < 0 then self.selected += len
    if self.selected >= len then self.selected -= len

    if self.input.attack.clicked and len > 0 then
        item = self.player.inventory.items
        self.player.inventory.items.remove(selected)
        self.player.activeItem = item
        self.game.setMenu(null)
    end if
end function

// @param {Screen} screen
InventoryMenu.render = function(screen)
    Font.renderFrame(screen, "inventory", 1, 1, 12, 11)
    self.renderItemList(screen, 1, 1, 12, 11, self.player.inventory.items, self.selected)
end function

return InventoryMenu
