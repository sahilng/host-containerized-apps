from flask import Flask
app = Flask(__name__)

def say_hello(name = None):
	if name and len(name.strip()) > 0:
		return f"Hello, <span style='color:green'>{name.title()}</span>!"
	else:
		return "Hello!"

@app.route("/")
def index():
	return say_hello()

@app.route("/<string:name>")
def hello(name: str):
	return say_hello(name)

if __name__ == "__main__":
	app.run(host="0.0.0.0", port=5000)