from flask import Flask, request, render_template

import feedparser
from transformers import pipeline

app = Flask(__name__)

### ROUTES ###
@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

@app.route('/headlines', methods=['POST'])
def headlines():
    ticker = request.form.get('ticker')

    data = get_headlines(ticker)
    if data['success'] == False:
        return render_template('error.html', data=data['error'])
    
    headlines = sentimental_analysis(data['headlines'])

    return render_template('headlines.html', data=headlines)

### FUNCTIONS ###
def get_headlines(ticker):
    url = f'https://finance.yahoo.com/rss/headline?s={ticker}'

    try:
        feed = feedparser.parse(url)

        if not feed.entries:
            return {'success': False, 'error': 'Ticker Symbol not found.'}

        news_headlines = [{'title': entry.title, 'link': entry.link} for entry in feed.entries]
        
        return {'success': True, 'headlines': news_headlines}
    
    except Exception as e:
        return {'success': False, 'error': str(e)}

def sentimental_analysis(news_headlines):
    pipe = pipeline('text-classification', model='./models/ProsusAI/finbert/models--ProsusAI--finbert/snapshots/4556d13015211d73dccd3fdd39d39232506f3e43')
    for i, headline in enumerate(news_headlines):
        sentiment = pipe(headline['title'])[0]
        news_headlines[i].update(sentiment)
    
    return news_headlines

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)