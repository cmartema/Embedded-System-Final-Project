import binascii
from PIL import Image
import os

INPUT_DIR = '../../Graphics'
OUTPUT_DIR = 'mif_output'


def image_to_mif(image, filename, output_dir):
    width, height = image.size
    pixels = list(image.getdata())
    with open(os.path.join(output_dir, filename), 'w') as f:
        f.write(f"DEPTH = {width*height};\nWIDTH = 24;\nADDRESS_RADIX = UNS;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n")
        for i, pixel in enumerate(pixels):
            f.write(f"{i} : {pixel[0]:02x}{pixel[1]:02x}{pixel[2]:02x};\n")
        f.write("END;\n")


def png_to_hex():
    for filename in os.listdir(INPUT_DIR):
        if filename.endswith('.png'):
            with open(os.path.join(DIR, filename), 'rb') as f:
                content = f.read()
                hex_content = binascii.hexlify(content)
                with open("hex_" + filename + ".txt", 'w') as d:
                    d.write(f"{hex_content.decode('utf-8')}")
                    d.write("\n")
                    d.close()
            f.close()

# Create the output directory if it doesn't exist
os.makedirs(OUTPUT_DIR, exist_ok=True)

for filename in os.listdir(INPUT_DIR):
    if filename.endswith('.png'):
        with Image.open(os.path.join(INPUT_DIR, filename)) as img:
            img = img.resize((32, 32))
            image_to_mif(img, "mif_" + os.path.splitext(filename)[0] + ".mif", OUTPUT_DIR)

     