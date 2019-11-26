#!/usr/bin/env python
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
if args.type == "anagram":
    results = scrabble.anagram(args.word)
elif args.type == "regex":
    results = scrabble.regex(args.word)
else:
    results = scrabble.permute(args.word)
template = '''
word\tlen\tval
====\t===\t===

{{#results}}
{{word}}\t{{len}}\t{{val}}
{{/results}}
'''
print(pystache.render(template, {"results": results}))
