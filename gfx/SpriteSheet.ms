SpriteSheet = {}

// {Image} image
SpriteSheet.init = function(image)
    self.width = image.width
    self.height = image.height
    
    self.pixels = []
    for y in range(0, self.height - 1)
        for x in range(0, self.width - 1)
            c = image.pixel(x, y) // Get the HTML color.
            c = color.toList(c) // Get an RGB list.
            pixels.push floor(bitAnd(c, 255) / 64) // Convert to range [0-3].
        end for
    end for

    return self
end function

return SpriteSheet
