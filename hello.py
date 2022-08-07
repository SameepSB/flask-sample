from flask import Flask
from flask import render_template
from flask import request

app = Flask(__name__)


@app.route('/', methods=['GET', 'POST'])
def hello_world():
    return '<h1>Hello world from Kubernetes!</h1>'


if __name__ == "__main__":
    app.run(debug=True)
