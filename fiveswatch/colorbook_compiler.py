import sys
import json
# import argparse

def compile_book(filename):
    csvfile = open(filename, 'r')
    bookname = input("Name this color book: ")
    dataobject = {}
    dataobject['name'] = bookname
    colorarray = []
    for line in csvfile:
        colorobj = {}
        name, triplet = line.split(',')
        name = name.rstrip()
        triplet = triplet.rstrip()
        colorobj['name'] = name
        colorobj['triplet'] = triplet
        colorarray.append(colorobj)
        # print("name: {} hex: {}".format(name, triplet))
    dataobject['colors'] = colorarray

    with open(bookname + '.json', 'w') as jsonfile:
        json.dump(dataobject, jsonfile, indent=2)



def main():
    # ap = argparse.ArgumentParser(description='Prepare a colorbook from a list of colors')
    # ap.add_argument('file')
    if (len(sys.argv) > 1):
        compile_book(sys.argv[1])


if __name__ == '__main__':
    main()