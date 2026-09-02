from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>CI/CD Pipeline Project</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                margin-top: 100px;
                background-color: #f4f4f4;
            }
            h1 {
                color: #2c3e50;
            }
            p {
                color: #555;
                font-size: 18px;
            }
        </style>
    </head>
    <body>
        <h1>Hello from CI/CD Pipeline!</h1>
        <p>Successfully deployed using Flask, Docker, GitHub Actions, Terraform, Amazon ECR, and Amazon ECS Fargate.</p>
    </body>
    </html>
    """


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "application": "cicd-ecs-project",
        "aws_region": "us-west-2"
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)