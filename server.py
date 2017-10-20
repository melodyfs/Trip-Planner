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
# app.bcrypt_rounds = 12
api = Api(app)

def auth_validation(email, password):
    user_collection = app.db.user
    myUser = user_collection.find_one({'email': email})
    user_password = myUser['password']

    if myUser is None:
        return ({"error": "Email not found"}, 404, None)
    else:
        encodedPassword = password.encode('utf-8')
        if bcrypt.hashpw(encodedPassword, user_password) == user_password:
            return True
        else:
            return False

def auth_function(func):
    def wrapper(*args, **kwargs):
        auth = request.authorization
        if not auth_validation(auth.username, auth.password):
            return ({'error': 'Could not verify your credentials'}, 401,
                    {'WWW-Authenticate': 'Basic realm="Login Required"'})
        return func(*args, **kwargs)
    return wrapper



class User(Resource):

    def post(self):
        new_user = request.json
        user_collection = app.db.user

        if 'email' in new_user and 'password' in new_user:
            user = user_collection.find_one({'email': new_user.get('email')})
            if user:
                 return ({'error': 'email already exists'}, 409, None)
            else:

                password = new_user.get('password')
                app.bcrypt_rounds = 12
                # Convert password to utf-8 string
                encodedPassword = password.encode('utf-8')
                hashed = bcrypt.hashpw(encodedPassword, bcrypt.gensalt(app.bcrypt_rounds))
                result = user_collection.insert({'email': new_user.get('email'),
                                                 'password': hashed})

                user.pop(password)

                return (user, 201, None)
        else:
            return ({"error": "Can't create user"}, 400, None)

    @auth_function
    def get(self):
        user_collection = app.db.user
        email = request.args.get("email")
        # password = request.args.get('password')
        myUser = user_collection.find_one({'email': email})

        if myUser is None:
            return ({"error": "Email not found"}, 404, None)
        else:
            # encodedPassword = password.encode('utf-8')
            # if bcrypt.hashpw(encodedPassword, myUser['password']) == myUser['password']:
            myUser.pop('password')
            return (myUser, 200, None)
            # else:
            #     return ({"error": "Invalid credentials"}, 400, None)


    @auth_function
    def patch(self):
        email = request.args.get('email')

        update_ = request.json
        # new_name = update_.get('name')
        new_password = update_.get('password')
        new_email = update_.get('email')
        user_collection = app.db.user

        if email is not None:
            user = user_collection.find_one({'email': email})
            if new_email:
                 user["email"] = new_email
            # if new_name:
            #     user['name'] = new_name
            if new_password:
                user['password'] = new_password
            user_collection.save(user)

            return (user, 200, None)
        else:
            return ({"error": "Can't modify the user"}, 404, None)

    @auth_function
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



class Trip(Resource):

    # @auth_function
    def post(self):
        args = request.args
        new_trip = request.json
        user_collection = app.db.user

        email = args.get('email')
        destination = new_trip.get('destination')
        # waypoints = new_trip.get('waypoints')
        completion = new_trip.get("completion")
        start_date = new_trip.get("start_date")
        end_date = new_trip.get("end_date")
        user = user_collection.find_one({'email': email})

        # pdb.set_trace()

        if 'email' in args:
            if destination not in user:
                result = user_collection.update_one(
                    {'email': email},
                    {'$push': {
                        "trips": {
                            'destination': destination,
                        # 'waypoints': waypoints,
                            "completion": completion,
                            "start_date": start_date,
                            "end_date": end_date
                            }
                            }
                        })

            return result
        else:
            return ({"error": "Can't create trip"}, 404, None)

    # @auth_function
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

    # @auth_function
    def patch(self):
        args = request.args
        destination = args.get("destination")
        email = args.get("email")
        user_collection = app.db.user
        user = user_collection.find_one({'email': email})

        update_ = request.json
        new_destination = update_.get('destination')
        new_completion = update_.get('completion')
        new_start_date = update_.get('start_date')
        new_end_date = update_.get('end_date')


        if user:
            if destination:
                result = user_collection.update_one(
                    {'email': email},
                    {'$set': {
                        "trips": {
                            'destination': new_destination,
                        # 'waypoints': waypoints,
                            "completion": new_completion,
                            "start_date": new_start_date,
                            "end_date": new_end_date
                            }
                            }
                        })
                # if new_destination:
                #     user{['destination']} = new_destination
                # if new_completion:
                #     user['completion'] = new_completion
                # if new_start_date:
                #     user['start_date'] = new_start_date
                # if new_end_date:
                #     user['end_date'] = new_end_date
                # user_collection.save(user)

            return (result, 200, None)
        else:
            return ({"error": "Can't modify the trip"}, 404, None)

    # @auth_function
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



##api routes
api.add_resource(User,'/user/')
api.add_resource(Trip,'/user/trips/')

#  Custom JSON serializer for flask_restful
@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp

if __name__ == '__main__':
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
