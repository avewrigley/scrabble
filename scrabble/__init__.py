#!/usr/bin/env python
import re


word_file = "words.txt"
with open(word_file) as x:
    words = list(map(lambda w: w.rstrip().lower(), x.readlines()))


value = {
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


def calculate_value(word):
    v = 0
    for letter in word:
        v += value[letter.upper()]
    return v


def map_results(results):
    return map(
        lambda w: {
            'word': w,
            'len': len(w),
            'val': calculate_value(w)
        }, results
    )


def regex(word):
    results = []
    for w in words:
        if re.search(word, w):
            results.append(w)
    return map_results(sorted(results, key=len, reverse=False))


def permute(word):
    results = []
    c1 = '^'+''.join(map(lambda w: w+'?', sorted(word)))+'$'
    for w in words:
        c2 = ''.join(sorted(w))
        if re.search(c1, c2):
            results.append(w)
    return map_results(sorted(results, key=len, reverse=True))


def anagram(word):
    results = []
    for w in words:
        if re.search(''.join(sorted(word)), ''.join(sorted(w))):
            for l in word:
                p = re.compile('('+l+')')
                w = p.sub(lambda pat: pat.group(1).upper(), w, 1)
            results.append(w)
    return map_results(sorted(results, key=len, reverse=False))
