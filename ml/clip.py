import torch
import clip
from PIL import Image
import numpy as np
import sys

device = "cuda" if torch.cuda.is_available() else "cpu"
model, preprocess = clip.load("ViT-B/32", device=device)

img_inp = Image.open(sys.argv[1])
image = preprocess(img_inp).unsqueeze(0).to(device)
labels = ["Man with weights", "Ronnie Coleman", "Arnold Schwarzenegger"]
text = clip.tokenize(labels).to(device)


with torch.no_grad():
    image_features = model.encode_image(image)
    text_features = model.encode_text(text)
    
    logits_per_image, logits_per_text = model(image, text)
    probs = logits_per_image.softmax(dim=-1).cpu().numpy()


print(labels[np.argmax(probs)])