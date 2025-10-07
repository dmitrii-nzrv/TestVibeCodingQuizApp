#!/usr/bin/env python3
from PIL import Image, ImageDraw

SIZE = 1024

def draw_gradient(draw):
    # vertical gradient from violet to indigo
    top = (138, 43, 226)   # blueviolet
    bottom = (75, 0, 130)  # indigo
    for y in range(SIZE):
        t = y / (SIZE - 1)
        r = int(top[0] * (1 - t) + bottom[0] * t)
        g = int(top[1] * (1 - t) + bottom[1] * t)
        b = int(top[2] * (1 - t) + bottom[2] * t)
        draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

def draw_book(draw):
    # simple minimalist open book silhouette using rounded rectangles and triangle
    margin = int(SIZE * 0.15)
    midx = SIZE // 2
    top_y = int(SIZE * 0.28)
    bottom_y = int(SIZE * 0.75)
    spine_width = int(SIZE * 0.02)

    # left page
    draw.rounded_rectangle([margin, top_y, midx - spine_width, bottom_y], radius=int(SIZE*0.04), outline=(255,255,255), width=int(SIZE*0.02))
    # right page
    draw.rounded_rectangle([midx + spine_width, top_y, SIZE - margin, bottom_y], radius=int(SIZE*0.04), outline=(255,255,255), width=int(SIZE*0.02))
    # spine curve (simple line)
    draw.line([(midx, top_y), (midx, bottom_y)], fill=(255,255,255), width=int(SIZE*0.02))
    # sparkles
    s = int(SIZE*0.015)
    for cx, cy in [(int(SIZE*0.35), int(SIZE*0.24)), (int(SIZE*0.65), int(SIZE*0.22)), (int(SIZE*0.5), int(SIZE*0.18))]:
        draw.line([(cx - s, cy), (cx + s, cy)], fill=(255,255,255), width=int(SIZE*0.01))
        draw.line([(cx, cy - s), (cx, cy + s)], fill=(255,255,255), width=int(SIZE*0.01))

def main():
    img = Image.new("RGB", (SIZE, SIZE), (0, 0, 0))
    draw = ImageDraw.Draw(img)
    draw_gradient(draw)
    draw_book(draw)
    img.save("AppIcon-1024.png", format="PNG")

if __name__ == "__main__":
    main()


