#!/usr/bin/env python3
"""
scrabble - module to provide tools to help solving scrabble games
"""
import argparse
import re
import pystache

WORD_FILE = "words.txt"
with open(WORD_FILE) as x:
    WORDS = list(map(lambda w: w.rstrip().lower(), x.readlines()))

VALUE = {
    'A': 1,
    'B': 3,
    'C': 3,
    'D': 2,
    'E': 1,
    'F': 4,
    'G': 2,
    'H': 4,
    'I': 1,
    'J': 8,
    'K': 5,
    'L': 1,
    'M': 3,
    'N': 1,
    'O': 1,
    'P': 3,
    'Q': 10,
    'R': 1,
    'S': 1,
    'T': 1,
    'U': 1,
    'V': 4,
    'W': 4,
    'X': 8,
    'Y': 4,
    'Z': 10,
}


def calculate_value(letter_list):
    """
    calculate the scrabble value for a set of letters
    """
    val = 0
    for letter in letter_list:
        val += VALUE[letter.upper()]
    return val


def map_results(results):
    """
    map a list of result words to a list of dictionaries keyed on word, len,
    and val
    """
    return map(
        lambda w: {
            'word': w,
            'len': len(w),
            'val': calculate_value(w)
        }, results
    )


def regex(re_str):
    """
    return a list of words matching a regex
    """
    results = []
    for word in WORDS:
        if re.search(re_str, word):
            results.append(word)
    return map_results(sorted(results, key=len, reverse=False))


def permute(letter_list):
    """
    return a list of word that are permutations of the letters in letter_list
    """
    results = []
    re_str = '^'+''.join(map(lambda w: w+'?', sorted(letter_list)))+'$'
    for word in WORDS:
        letters = ''.join(sorted(word))
        if re.search(re_str, letters):
            results.append(word)
    return map_results(sorted(results, key=len, reverse=True))


def anagram(letter_list):
    """
    return a list of words that contain all of the letters in letter_list
    """
    results = []
    pat = '.*'.join(sorted(letter_list))
    for word in WORDS:
        sorted_word = ''.join(sorted(word))
        if re.search(pat, sorted_word):
            for letter in letter_list:
                pattern = re.compile('('+letter+')')
                word = pattern.sub(lambda pat: pat.group(1).upper(), word, 1)
            results.append(word)
    return map_results(sorted(results, key=len, reverse=False))


def main():
    """
    main
    """
    parser = argparse.ArgumentParser(description='Cheat at scrabble.')
    parser.add_argument('word')
    parser.add_argument(
        '--anagram', action='store_true', help='set type to anagram'
    )
    parser.add_argument(
        '--permute', action='store_true', help='set type to permute'
    )
    parser.add_argument(
        '--regex', action='store_true', help='set type to regex'
    )
    parser.add_argument(
        '--type',
        choices=['anagram', 'permute', 'regex'],
        help='type of guess (anagram|permute|regex)'
    )
    args = parser.parse_args()
    word = args.word.lower()
    if args.anagram or args.type == "anagram":
        results = anagram(word)
    elif args.regex or args.type == "regex":
        results = regex(word)
    elif args.permute or args.type == "permute":
        results = permute(word)
    else:  # default to permute
        results = permute(word)
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
        pystache.render(
            template, {"results": results, "nresults": len(results)}
        )
    )


if __name__ == "__main__":
    main()
