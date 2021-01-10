#!/usr/bin/env python3

import argparse
import datetime
import os
import subprocess

class VerifiedThought:
    date = None
    filename = None

    def __init__(self, date, filename):
        self.date = date
        self.filename = filename

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('thoughts_dir', metavar='<dir>',
            help='directory containing the target thoughts')
    args = parser.parse_args()

    thoughts_dir = args.thoughts_dir
    if not os.path.isdir(thoughts_dir):
        print('%s not exists' % thoughts_dir)
        exit(1)

    verified = {}
    thought_titles = []
    for thought_file in os.listdir(thoughts_dir):
        path = os.path.join(thoughts_dir, thought_file)
        if not os.path.isfile(path):
            print('%s: not file' % path)
            continue

        date = None
        with open(path, 'r') as f:
            content = f.read()
        idx = content.find('\n\n')
        if idx == -1:
            print('cannot find date in %s' % thought_file)
            exit(1)

        date_line = content[:idx]
        date = datetime.datetime.strptime(date_line,
                '%a %b %d %H:%M:%S %Y %z')
        verified[content] = VerifiedThought(date, thought_file)

    thoughts = sorted(list(verified.values()), key=lambda x: x.date)
    for v in thoughts:
        print(v.filename)

if __name__ == '__main__':
    main()
