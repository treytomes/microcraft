ContainerMenu = new Menu

// @param {Player} player
// @param {string} title
// @param {Inventory} container
ContainerMenu.make = function(player, title, container)
    super.make
    self.selected = 0
    self.oSelected = 0
    self.window = 0;

    self.player = player
    self.title = title
    self.container = container
    return self
end function

ContainerMenu.tick = function()
    if self.input.menu.clicked then self.game.setMenu(null)

    if self.input.left.clicked then
        self.window = 0
        tmp = self.selected
        self.selected = self.oSelected
        self.oSelected = tmp
    end if
    if self.input.right.clicked then
        self.window = 1
        tmp = self.selected
        self.selected = self.oSelected
        self.oSelected = tmp
    end if

    i = iif(self.window == 1, self.player.inventory, self.container)
    i2 = iif(self.window == 0, self.player.inventory, self.container)

    len = i.items.len
    if self.selected < 0 then self.selected = 0
    if self.selected >= len then self.selected = len - 1

    if self.input.up.clicked then self.selected -= 1
    if self.input.down.clicked then self.selected += 1

    if len == 0 then self.selected = 0
    if self.selected < 0 then self.selected += len
    if self.selected >= len then self.selected -= len

    if self.input.attack.clicked and len > 0 then
        i2.add(self.oSelected, i.items.remove(self.selected))
        if self.selected >= i.items.len then self.selected = i.items.len - 1
    end if
end function

// @param {Screen} screen
ContainerMenu.render = function(screen)
    if self.window == 1 then screen.setOffset(6 * 8, 0)
    Font.renderFrame(screen, self.title, 1, 1, 12, 11)
    self.renderItemList(screen, 1, 1, 12, 11, self.container.items, iif(self.window == 0, self.selected, -self.oSelected - 1))

    Font.renderFrame(screen, "inventory", 13, 1, 13 + 11, 11)
    self.renderItemList(screen, 13, 1, 13 + 11, 11, self.player.inventory.items, iif(self.window == 1, self.selected, -self.oSelected - 1))
    screen.setOffset(0, 0)
end function

return ContainerMenu