#!/usr/bin/env python3
import argparse
import pystache
import scrabble


parser = argparse.ArgumentParser(description='Cheat at scrabble.')
parser.add_argument('word')
parser.add_argument(
    '--type',
    choices=['anagram', 'permute', 'regex'],
    help='type of guess (anagram|permute|regex)'
)
args = parser.parse_args()
word = args.word.lower()
if args.type == "anagram":
    results = scrabble.anagram(word)
elif args.type == "regex":
    results = scrabble.regex(word)
else:
    results = scrabble.permute(word)
results = list(results)
template = '''
word\tlen\tval
====\t===\t===

{{#results}}
{{word}}\t{{len}}\t{{val}}
{{/results}}

{{nresults}} results
'''
print(
    pystache.render(template, {"results": results, "nresults": len(results)})
)
