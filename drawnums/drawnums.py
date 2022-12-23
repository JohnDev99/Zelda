from PIL import Image
from PIL import ImageFont
from PIL import ImageDraw

TILES_HIGH = 0
TILES_WIDE = 0

TILE_SIZE = 16

if __name__ == '__main__':
    img = Image.open('tiles.png')
    draw = ImageDraw.Draw(img)

    font = ImageFont.truetype('04B_03__.TTF', 8)

    counter = 1

    for y in range(TILES_HIGH):
        for x in range(TILES_WIDE):
            draw.text((x * TILE_SIZE + 1, y * TILE_SIZE), str(counter), (0, 0, 0), font=font)
            draw.text((x * TILE_SIZE, y * TILE_SIZE + 1), str(counter), (0, 0, 0), font=font)
            draw.text((x * TILE_SIZE, y * TILE_SIZE), str(counter), (255, 0, 255), font=font)
            counter += 1
    

    img.save('tiles_numbered.png')