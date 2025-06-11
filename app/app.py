from flask import Flask, request, render_template

import feedparser

import requests
import os

app = Flask(__name__)

HF_API_URL = "https://router.huggingface.co/hf-inference/models/ProsusAI/finbert"
HF_API_TOKEN = os.getenv("HF_API_TOKEN")  

headers = {"Authorization": f"Bearer {os.environ['HF_API_TOKEN']}"}

def run_inference_remote(text):
    response = requests.post(
        HF_API_URL,
        headers=headers,
        json={"inputs": text}
    )
    if response.status_code == 200:
        predictions = response.json()[0]
        best_pred = max(predictions, key=lambda x: x['score'])
        return best_pred
    else:
        return {"label": "error", "score": 0.0, "error": response.text}


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
    for i, headline in enumerate(news_headlines):
        sentiment = run_inference_remote(headline['title'])
        news_headlines[i].update(sentiment)
    
    return news_headlines

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)