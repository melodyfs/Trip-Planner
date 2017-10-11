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

        if 'name' in new_user and 'email' in new_user and 'password' in new_user:
            user = user_collection.find_one({'email': new_user.get('email')})
            if user:
                 return ({'error': 'email already exists'}, 409, None)
            else:
                result = user_collection.insert_one(new_user)
                return (result, 201, None)
        else:
            return ({"error": "Can't create user"}, 400, None)


    def get(self):
        user_collection = app.db.user
        email = request.args.get("email")
        myUser = user_collection.find_one({'email': email})

        if myUser is None:
            response = jsonify(data=[])
            return ({"error": "Can't get the user"}, 404, None)
        else:
            return myUser

    def patch(self):
        email = request.args.get('email')

        update_ = request.json
        name = update_.get('name')
        password = update_.get('password')
        new_email = update_.get('email')
        user_collection = app.db.user

        if email:
            myUser = user_collection.update_one(
                {"email": email},
                {
                    '$set': {
                        "email": new_email,
                        "name": name,
                        "password":password
                        }
                        }
                )
            return myUser
        else:
            return ({"error": "Can't modify the user"}, 404, None)

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
        args = request.args
        new_trip = request.json
        user_collection = app.db.user

        email = args.get('email')
        destination = new_trip.get('destination')
        waypoints = new_trip.get('waypoints')
        completion = new_trip.get("completion")
        start_date = new_trip.get("start_date")
        end_date = new_trip.get("end_date")

        pdb.set_trace()
        if 'email' in args :
            result = user_collection.update_one(
                {"email": email},
                {'$set': {
                "destination": destination,
                "waypoints": waypoints,
                "completion": completion,
                "start_date": start_date,
                "end_date": end_date
            }
        })
            return result
        else:
            return ({"error": "Can't create trip"}, 404, None)

    def get(self):
        args = request.args
        destination = args.get("destination")
        email = args.get("email")
        user_collection = app.db.user

        if 'email' in args and 'destination' in args:
            trip = user_collection.find_one({'destination': destination})
            return trip
        else:
            return ({"error": "Can't find the trip"}, 404, None)

    def patch(self):
        args = request.args
        destination = args.get("destination")
        email = args.get("email")
        user_collection = app.db.user

        if 'email' in args and 'destination' in args:
            trip = user_collection.update_one(
                {'email': email},
                {"$set":
                 {'destination': destination}
                 })
            return trip
        else:
            return ({"error": "Can't modify the trip"}, 404, None)

    def delete(self):
        args = request.args
        destination = args.get("destination")
        email = args.get("email")
        user_collection = app.db.user

        if 'email' in args and 'destination' in args:
            trip = user_collection.delete_one({'destination': destination})
            return trip
        else:
            return ({"error": "Can't delete the trip"}, 404, None)



## Add api routes here
api.add_resource(User,'/user/')
api.add_resource(Trip,'/trip/')
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
