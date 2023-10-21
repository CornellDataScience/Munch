from collections import defaultdict
from neo4j import GraphDatabase, basic_auth
from flask import Flask, request, jsonify
from flask_restful import Resource, Api
import pandas as pd
from werkzeug.utils import secure_filename

from dotenv import load_dotenv, find_dotenv
import os

# Load dotenv file
load_dotenv(find_dotenv())

app = Flask(__name__)
api = Api(app)

app.config['UPLOADS'] = 'uploads/'

# make the UPLOADS folder if not already there
if not os.path.exists(app.config['UPLOADS']):
    os.makedirs(app.config['UPLOADS'])

# connect to n4jDB instance using credentials from dotenv file

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
            filepath = os.path.join(app.config['UPLOADS'], filename)
            file.save(filepath)

        # read specified excel file
        # dfi is the datatable of ingredients
        dfi = pd.read_excel(filepath, sheet_name='Ingredients')

        # dfr is the datatable of recipes
        dfr = pd.read_excel(filepath, sheet_name='Recipes')

        # populate the database with the processed datatables
        populate_db(dfi, dfr)

        return {'message': 'File processed, database populated'}, 201


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

    recipe_pantry = defaultdict(list)

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


# add upload excel resource to endpoint
api.add_resource(UploadExcel, '/upload')


class Nutrients(Resource):
    def get(self, food: str):
        # Find the macronutrient breakdown of a given food

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


# add nutrients resource to endpoint
api.add_resource(Nutrients, '/nutrients/<string:food>')


if __name__ == "__main__":
    app.run(debug=True)
