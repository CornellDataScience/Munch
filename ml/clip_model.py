import torch
import clip
from PIL import Image
import numpy as np
import sys


def classify_img(pil_img: Image.Image, labels: list[str]) -> str:
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model, preprocess = clip.load("ViT-B/32", device=device)

    #im = Image.open(sys.argv[1])
    # im_crop = im.crop((int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])))

    img_inp = pil_img
    image = preprocess(img_inp).unsqueeze(0).to(device)
    text = clip.tokenize(labels).to(device)

    with torch.no_grad():
        image_features = model.encode_image(image)
        text_features = model.encode_text(text)
        
        logits_per_image, logits_per_text = model(image, text)
        probs = logits_per_image.softmax(dim=-1).cpu().numpy()

    return labels[np.argmax(probs)]