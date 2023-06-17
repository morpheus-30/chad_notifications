from flask import *
from flask_cors import CORS
from meraopenai import ask


app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

@app.route("/",methods = ["GET"])
def getMessage():
    # data = request.get_json()
    result = ask("Give message")
    return jsonify({'status': 200, 'message': result["message"]})
    
    


if __name__ == "__main__":
    app.run(debug=True,host="0.0.0.0")

