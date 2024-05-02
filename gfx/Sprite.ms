Sprite = {}

// {int} x
// {int} y
// {int} img
// {int} col
// {int} bits
Sprite.init = function(x, y, img, col, bits)
    self.x = x
    self.y = y
    self.img = img
    self.bits = bits

    return self
end function

return Sprite
