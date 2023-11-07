# from flask import Flask

# app = Flask(__name__)

# @app.route('/')
# def hello_world():
#     return 'Hello, World!'

# if __name__ == '__main__':
#     app.run(debug=True,port=8000)

from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
# Allow requests from any origin (replace '*' with your domain in production)
CORS(app)

@app.route('/', methods=['GET'])
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(debug=True, port=8000)
