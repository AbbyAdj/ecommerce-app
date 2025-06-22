import os
from app import app
from dotenv import load_dotenv
from waitress import serve

load_dotenv(override=True)

if __name__ == "__main__":
    env = os.getenv("FLASK_ENV", "dev-local")

    if env == "dev-local":
        app.run(debug=True, host="0.0.0.0", port=5000)
    elif env == "dev-deployed" or env == "prod-deployed":
        try:
            serve(app, host="0.0.0.0", port=8080)
        except Exception as e:
            pass
