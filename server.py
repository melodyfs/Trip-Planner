from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from utils.mongo_json_encoder import JSONEncoder
from bson.objectid import ObjectId
import bcrypt
import pdb

app = Flask(__name__)
mongo = MongoClient('localhost', 27017)
app.db = mongo.local
app.bcrypt_rounds = 12
api = Api(app)


## Write Resources here

class User(Resource):
    def post(self):
        new_user = request.json
        user_collection = app.db.user
        
        if new_user.get('name') and new_user.get('email') and new_user.get('password'):
            result = user_collection.insert_one(new_user)
            myUser = user_collection.find({'_id': ObjectId(result.insert_id)})
            return (result, 202, None)
        else:
            return ("nothing", 404, None)


    def get(self, myobject_id):
        user_collection = app.db.user
        myUser = user_collection.find_one({'_id': ObjectId(myobject_id)})

        if myUser is None:
            response = jsonify(data=[])
            response.status_code = 404
            return response
        else:
            return myUser
    def put(self, name):
        user_collection = app.db.user
        myUser = user_collection.find_one({'name': ""})


## Add api routes here
api.add_resource(User,'/user/', '/user/<string:myobject_id>')

#  Custom JSON serializer for flask_restful
@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp

if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request
    # related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
