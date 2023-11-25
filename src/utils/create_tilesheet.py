from PIL import Image


def create_transparent_tileset(ntiles, height):
    # calculate the width of the tileset
    width = ntiles * height

    # create a new RGBA image with a white background
    tileset = Image.new("RGBA", (width, height), (255, 255, 255, 255))

    # create progressively more transparent tiles
    for i in range(ntiles):
        # calculate the alpha value based on the current tile index
        alpha = int((i / (ntiles - 1)) * 255)

        # create a tile with the calculated alpha value
        tile = Image.new("RGBA", (height, height), (255, 0, 255, alpha))

        # paste the tile onto the tileset
        tileset.paste(tile, (i * height, 0))

    # save the tileset as a PNG file
    tileset.save("tileset.png")


def main():
    # Example usage with 10 tiles and a height of 32 pixels
    create_transparent_tileset(10, 32)


if __name__ == "__main__":
    main()
