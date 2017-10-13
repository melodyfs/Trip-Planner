import server
import unittest
import json
import bcrypt
import base64
from pymongo import MongoClient


class TripPlannerTestCase(unittest.TestCase):
    def setUp(self):

      self.app = server.app.test_client()
      # Run app in testing mode to retrieve exceptions and stack traces
      server.app.config['TESTING'] = True

      mongo = MongoClient('localhost', 27017)
      global db

      # Reduce encryption workloads for tests
      server.app.bcrypt_rounds = 4

      db = mongo.trip_planner_development
      server.app.db = db

      db.drop_collection('user')

    # User tests, fill with test methods
    def testCreateUser(self):

        self.app.post(
            '/user/',
            headers=None,
            data=json.dumps(dict(name="Melody", email="melody@example.com", password="mmm")),
            content_type='application/json')

        response = self.app.get('/user/', query_string=dict(email="melody@example.com"))
        response_json = json.loads(response.data.decode())

        self.assertEqual(response.status_code, 200)

    def test_existing_user(self):

        original = self.app.post(
            '/user/',
            headers=None,
            data=json.dumps(dict(name="M", email="mmm@example.com", password="pw")),
            content_type='application/json')
        response_json = json.loads(original.data.decode())
        self.assertEqual(original.status_code, 201)

        failure = self.app.post(
            '/user/',
            headers=None,
            data=json.dumps(dict(name="M", email="mmm@example.com", password="pw")),
            content_type='application/json')
        response_json = json.loads(failure.data.decode())
        self.assertEqual(failure.status_code, 409)

    def test_get_user(self):
        self.app.post(
            '/user/',
            headers=None,
            data=json.dumps(dict(name="Melody", email="melody@example.com", password="p")),
            content_type='application/json')

        response = self.app.get('/user/', query_string=dict(email="melody@example.com"))

        self.assertEqual(response.status_code, 200)


    def test_patch_user(self):
        original = self.app.post(
            '/user/',
            headers=None,
            data=json.dumps(dict(name="Joan", email="joan@example.com", password="pppp")),
            content_type='application/json')
        self.assertEqual(original.status_code, 201)

        update = self.app.patch(
            '/user/',
            headers=None,
            data=json.dumps(dict(name="Joan", email="j@example.com", password="ooooooo")),
             query_string=dict(email="joan@example.com"),
            content_type='application/json')
        self.assertEqual(update.status_code, 200)

        get_updated_user = self.app.get(
            '/user/',
            headers=None,
            query_string=dict(email="joan@example.com"),
            content_type='application/json')
        self.assertEqual(get_updated_user.status_code, 404)
    #


if __name__ == '__main__':
    unittest.main()
