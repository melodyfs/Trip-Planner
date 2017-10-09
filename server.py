from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from utils.mongo_json_encoder import JSONEncoder
from bson.objectid import ObjectId
import bcrypt
import pdb

app = Flask(__name__)
mongo = MongoClient('localhost', 27017)
app.db = mongo.trip_planner_development
app.bcrypt_rounds = 12
api = Api(app)


## Write Resources here

#Test uniqueness
#Able to delete, update user accounts
#Have to log in for getting the account
# password length

class User(Resource):


    def post(self):
        new_user = request.json
        user_collection = app.db.user

        if new_user.get('name') and new_user.get('email') and new_user.get('password'):
            result = user_collection.insert_one(new_user)
            myUser = user_collection.find({'_id': ObjectId(result.insert_id)})
            return (result, 202, Nsone)
        else:
            return ({"error": "Can't create user"}, 404, None)


    def get(self, myobject_id):
        user_collection = app.db.user
        myUser = user_collection.find_one({'_id': ObjectId(myobject_id)})

        if myUser is None:
            response = jsonify(data=[])
            return ({"error": "Can't create user"}, 404, None)
        else:
            return myUser

    def patch(self):
        params = request.args
        name_param = params['name']
        new_email = params['email']
        new_password = params['password']

        user_collection = app.db.user
        myUser = user_collection.update_one(
            {"email": new_email},
            {
                '$set': {
                    "name": name_param,
                    "password":new_password
                }
            }
        )
        return myUser

    def delete(self, myobject_id):
        user_collection = app.db.user
        params = request.args
        email = params['email']
        myUser = user_collection.delete_one({'email': email})

        if myUser is None:
            response = jsonify(data=[])
            response.status_code = 404
            return response
        else:
            return myUser


#

class Trip(Resource):

    def post(self):
        new_trip = request.json
        user_collection = app.db.user
        email = new_trip.get('email')
        destination = new_trip.get('destination')
        place_name = new_trip.get('place_name')
        latitude = new_trip.get('latitude')
        longtitude = new_trip.get("longtitude")
        completion = new_trip.get("Complete")
        start_date = new_trip.get("start_date")
        end_date = new_trip.get("end_date")

        if email and destination and place_name and latitude and longtitude and completion and start_date and end_date:
            result = user_collection.insert_one({
                "Destination": destination {
                    waypoints: [{
                    "Place Name": place_name,
                    "Longtitude": longtitude,
                    "Latitude": latitude

                    }]
                }
            })

        pass

    def get(self):
        pass



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
