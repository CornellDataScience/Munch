from collections import defaultdict
from neo4j import GraphDatabase, basic_auth
from flask import Flask, request, jsonify
from flask_restful import Resource, Api
import pandas as pd
from werkzeug.utils import secure_filename
import os
from py2neo import Graph
from flask import Flask, jsonify, request, render_template, redirect


app = Flask(__name__)
api = Api(app)

app.config['UPLOADS'] = 'uploads/'

# make the UPLOADS folder if not already there
if not os.path.exists(app.config['UPLOADS']):
    os.makedirs(app.config['UPLOADS'])

# connect to n4jDB instance
graph = Graph(
    "bolt://localhost:7687", auth=("neo4j", "12345678"))

# Route to upload image
@app.route('/upload-image', methods=['GET', 'POST'])
def upload_image():
    if request.method == "POST":
        if request.files:
            image = request.files["image"]
            print(image)
            image.save(os.path.join(app.config["IMAGE_UPLOADS"], image.filename))                                          
            return redirect(request.url)
    return render_template("upload_image.html")
    

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
        graph.run(query)

    recipe_pantry = defaultdict(list)

    for recipe in (list(df2.columns)[1:]):
        graph.run(
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
                graph.run(
                    query
                )

    # add resource to endpoint
api.add_resource(UploadExcel, '/upload')


if __name__ == "__main__":
    app.run(debug=True)
