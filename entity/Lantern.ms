Lantern = new Furniture

// @returns {Lantern}
Lantern.make = function()
    super.make("Lantern")
    self.col = Color.get(-1, 000, 111, 555)
    self.sprite = 5
    self.xr = 3
    self.yr = 2
    return self
end function

// @returns {int}
Lantern.getLightRadius = function()
    return 8
end function

return Lantern
