from neo4j import GraphDatabase
from flask import Flask, request
from flask_restful import Resource, Api
import pandas as pd
from werkzeug.utils import secure_filename
import os
from dotenv import load_dotenv, find_dotenv
from ml.clip_test import classify_img
from PIL import Image
import uuid

load_dotenv(find_dotenv())

app = Flask(__name__)
api = Api(app)

app.config['DATA_UPLOADS'] = 'api/data_uploads/'
app.config['IMG_UPLOADS'] = 'api/img_uploads/'

# make the UPLOADS folder if not already there
if not os.path.exists(app.config['DATA_UPLOADS']):
    os.makedirs(app.config['DATA_UPLOADS'])
if not os.path.exists(app.config['IMG_UPLOADS']):
    os.makedirs(app.config['IMG_UPLOADS'])

driver = GraphDatabase.driver(uri=os.environ.get("DATABASE_URL"), auth=(
    os.environ.get("DATABASE_USERNAME"), os.environ.get("DATABASE_PASSWORD")))
session = driver.session()


class UploadExcel(Resource):

    # process for uploading, reading excel file, and populating database
    def post(self):

        # checks if the request includes the file specification

        if 'file' not in request.files:
            return {'error': 'No File'}, 400

        # set file to be the file specified
        file = request.files['file']

        # handles if no file selected
        if file.filename == '':
            return {'error': 'No selected file'}, 400

        # save the filepath
        if file:
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['DATA_UPLOADS'], filename)
            file.save(filepath)

        # read specified excel file
        # dfi is the datatable of ingredients
        dfi = pd.read_excel(filepath, sheet_name='Ingredients')

        # dfr is the datatable of recipes
        dfr = pd.read_excel(filepath, sheet_name='Recipes')

        # populate the database with the processed datatables
        populate_db(dfi, dfr)

        return {'message': 'File processed, database populated'}, 201


class ImageUpload(Resource):
    def post(self):
        if 'file' not in request.files:
            return {'error': 'No File'}, 400

        # set file to be the file specified
        image = request.files['file']

        # generate filename
        filename = secure_filename(str(uuid.uuid4()))

        if image:
            filepath = os.path.join(app.config['IMG_UPLOADS'], filename)
            image.save(filepath)

        return {'message': 'Image uploaded', 'file_id': filename}, 201


class Model(Resource):
    def get(self, food_id: str):
        filepath = os.path.join(app.config['IMG_UPLOADS'], food_id)

        image = Image.open(filepath)

        if image:
            name = classify_img(image).lower().replace(' ', '%20')
            return {'name': name}, 201

        return {'error': "No file found"}, 401


class Nutrients(Resource):
    def get(self, food: str):
        # Find the macronutrient breakdown of a given food

        food = food.lower()

        query = f"""MATCH path = (root:Recipe{{name:'{food}'}})-[:HAS*]->(macros)
                    WHERE NOT (macros)-->()
                    RETURN macros,  
                    REDUCE(quantity = 1.0, rel in relationships(path) | quantity * toFloat(rel.quantity)) AS quantity"""

        ingredients = session.run(query).data()

        # Check if food is an ingredient in DB
        if not ingredients:
            query = f"""MATCH  (root:Ingredient{{name:'{food}'}}) where not (root)-->() return root"""
            food = session.run(query).data()
            if food:
                food = food[0]['root']
                return {'carbs': food['carbs'], 'fats': food['fats'], 'protein': food['protein']}, 201
            return {'error': "Food not found"}, 400

        # If food is a recipe in DB
        carbs, fats, protein = 0.0, 0.0, 0.0
        for ingredient in ingredients:
            macros = ingredient['macros']
            carbs += float(macros['carbs']) * ingredient['quantity']
            fats += float(macros['fats']) * ingredient['quantity']
            protein += float(macros['protein']) * ingredient['quantity']
        return {'carbs': carbs, 'fats': fats, 'protein': protein}, 201


def populate_db(df1, df2):
    # macronutrient setup for each ingredient
    for _, r in df1.iterrows():
        ingredient = (r['Ingredients'])
        protein = r['Protein']
        carbs = r['Carbs']
        fats = r['Fats']

        # create the nodes representing each ingredient
        # create the edges representing macronutrient relationships

        """
            query handles the creation of the ingredient and macronutrient nodes,
            creating the edges that detail the amount of each macronutrient in every ingredient
            """
        query = (
            f"MERGE(i:Ingredient {{name: '{ingredient.lower()}', protein: '{protein}', carbs: '{carbs}', fats: '{fats}'}})"
        )

        # run query
        session.run(query)

    for recipe in (list(df2.columns)[1:]):
        session.run(
            f"MERGE(r:Recipe {{name:'{recipe.lower()}'}})"
        )

    for _, r in df2.iterrows():
        ingredient = (r['Ingredients'])
        for recipe in (list(df2.columns)[1:]):
            quantity = r[f'{recipe}']

            # if quantity of the ingredient in the recipe is greater than 0, add an edge between the ingredient and the recipe
            if quantity > 0:
                query = (
                    f"MATCH (r:Recipe {{name:'{recipe.lower()}'}}), (i:Ingredient {{name: '{ingredient.lower()}'}})"
                    f"MERGE (r)-[h:HAS]->(i)"
                    f"SET h.quantity = {quantity}"
                )
                session.run(
                    query
                )


# add resources to endpoint
api.add_resource(UploadExcel, '/upload')
api.add_resource(ImageUpload, '/img_upload')
api.add_resource(Nutrients, '/nutrients/<string:food>')
api.add_resource(Model, '/model/<string:food_id>')

if __name__ == "__main__":
    app.run(debug=True)
