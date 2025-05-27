from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        ticker = request.form.get('ticker')
        return render_template('index.html', ticker=ticker)

    return render_template('index.html')


if __name__ == '__main__':
    app.run(port=5000, debug=True)