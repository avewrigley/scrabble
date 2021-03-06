#!/usr/bin/env python3

from flask import Flask, request

import argparse
import pystache
import scrabble
import pprint

app = Flask(__name__)
pp = pprint.PrettyPrinter(depth=6)


parser = argparse.ArgumentParser(description='Cheat at scrabble webapp.')
parser.add_argument('--port', type=int, default=4000)
parser.add_argument('--host', default="0.0.0.0")
args = parser.parse_args()
@app.route('/')
def run():
    word = request.args.get("word")
    word = word if word else ''
    word = word.lower()
    type = request.args.get("type")
    type = type if type else 'permute'
    results = []
    if word:
        if type == "anagram":
            results = scrabble.anagram(word)
        elif type == "regex":
            results = scrabble.regex(word)
        else:
            results = scrabble.permute(word)
    with open('html.m', 'r') as template_file:
        template = template_file.read()
    return(
        pystache.render(
            template,
            {
                "results": results,
                "word": word,
                "type": type,
            }
        )
    )


if __name__ == '__main__':
    app.run(host=args.host, port=args.port)
