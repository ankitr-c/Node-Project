from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
# Allow requests from any origin (replace '*' with your domain in production)
CORS(app)

@app.route('/api/', methods=['GET'])
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(debug=True, port=8000)
