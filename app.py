from flask import Flask, request, render_template

import feedparser
from transformers import pipeline

app = Flask(__name__)

### ROUTES ###
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        ticker = request.form.get('ticker')
        return render_template('index.html', ticker=ticker)

    return render_template('index.html')

### FUNCTIONS ###
def get_headlines(ticker):
    url = f'https://finance.yahoo.com/rss/headline?s={ticker}'

    feed = feedparser.parse(url)
    news_headlines = []

    if not feed.entries:
        print(f'Error passing ticker: {ticker}')
    else:
        for entry in feed.entries:
            news_headlines.append([entry.title, entry.link])

def sentimental_analysis(headlines):
    pipe = pipeline('text-classification', model='ProsusAI/finbert')

if __name__ == '__main__':
    app.run(port=5000, debug=True)