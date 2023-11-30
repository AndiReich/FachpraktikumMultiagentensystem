from PIL import Image
import argparse


def get_cli_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--color', nargs='+', required=True, help='RGB color as three integers')
    parser.add_argument('-a', '--alpha', default=255, type=int, help='RGBA alpha value')
    parser.add_argument('-n', '--ntiles', default=10, help='number of tiles in sprite')
    parser.add_argument('-t', '--tilesize', default=16, help='tile size in pixels')
    parser.add_argument('-o', '--outfile', required=True, help='output file name')
    return parser.parse_args()


def create_transparent_tileset(color, target_alpha, ntiles, height, outfile):
    # calculate the width of the tileset
    width = ntiles * height

    # create a new RGBA image with a white background
    tileset = Image.new("RGBA", (width, height), (255, 255, 255, 255))

    # create progressively more transparent tiles
    for i in range(ntiles):
        # calculate the alpha value based on the current tile index
        alpha = int((i / (ntiles - 1)) * target_alpha)
        rgba = (*map(int, color), alpha)

        # create a tile with the calculated alpha value
        tile = Image.new("RGBA", (height, height), rgba)

        # paste the tile onto the tileset
        tileset.paste(tile, (i * height, 0))

    # save the tileset as a PNG file
    tileset.save(outfile + ".png")


def main():
    # Example usage with 10 tiles and a height of 32 pixels
    args = get_cli_args()
    create_transparent_tileset(args.color, args.alpha, args.ntiles, args.tilesize, args.outfile)


if __name__ == "__main__":
    main()
