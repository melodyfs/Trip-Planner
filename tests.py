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

      db = mongo.local
      server.app.db = db

      db.drop_collection('user')
      db.drop_collection('trips')

    # User tests, fill with test methods
    def testCreateUser(self):

        self.app.post(
            '/user/',
            headers=None,
            data=json.dumps(
                dict(name="Melody", email="melody@example.com")
                ),
            content_type='application/json',
           response = self.app.get('/user/', query_string=dict(email="melody@example.com"))

        )
        response_json = json.loads(response.data.decode())
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
