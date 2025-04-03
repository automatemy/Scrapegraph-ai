from flask import Flask, request, jsonify
from scrapegraphai.graphs import WebScraperGraph
from scrapegraphai.config import Configuration
import os

app = Flask(__name__)

@app.route('/scrape', methods=['POST'])
def scrape_website():
    try:
        # Get parameters from request
        data = request.json
        url = data.get('url')
        prompt = data.get('prompt', 'Extract all relevant information from the webpage')

        # Configure the scraper
        config = Configuration(
            llm_model="ollama/llama2",
            embedder_model="ollama/llama2",
            headless=True
        )

        # Create and run the scraper
        graph = WebScraperGraph(
            prompt=prompt,
            source=url,
            config=config
        )

        # Execute the scraping
        result = graph.run()

        return jsonify({
            'status': 'success',
            'data': result
        })

    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500

@app.route('/', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'message': 'ScrapegraphAI server is running'
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8084))
    app.run(host='0.0.0.0', port=port)
