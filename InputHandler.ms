Key = {}

Key.make = function()
    self.presses = 0
    self.absorbs = 0
    self.down = false
    self.clicked = false
    return self
end function

// @param {boolean} pressed
Key.toggle = function(pressed)
    if pressed != self.down then self.down = pressed
    if pressed then self.presses += 1
end function

Key.tick = function
    if self.absorbs < self.presses then
        self.absorbs += 1
        self.clicked = true
    else
        self.clicked = false
    end if
end function

InputHandler = {}

InputHandler.make = function()
    self.up = (new Key).make
    self.down = (new Key).make
    self.left = (new Key).make
    self.right = (new Key).make
    self.attack = (new Key).make
    self.menu = (new Key).make

    self.keys = [ self.up, self.down, self.left, self.right, self.attack, self.menu ]

    return self
end function

InputHandler.releaseAll = function
    for i in range(self.keys.len - 1)
        self.keys[i].down = false
    end for
end function

InputHandler.tick = function
    for i in range(self.keys.len - 1)
        self.keys[i].tick
    end for
end function

return InputHandler
