import ast

from flask import Flask, render_template

PAGES_FILE_PATH = 'pages.txt'
with open(PAGES_FILE_PATH) as pages_file:
    pages_str = pages_file.read()
    PAGES = ast.literal_eval(pages_str)

app = Flask(__name__)


@app.route('/<name>')
def say_hello(name):
    if name in PAGES:
        return f'Hello {name}!\n'
    else:
        return render_template('404.html'), 404


if __name__ == '__main__':
    app.run()
