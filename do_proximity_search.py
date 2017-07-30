#!/usr/bin/python

import requests
import sys

def main():
    https_request = "https://cle.cit.api.here.com/2/search/bbox.json"
    payload={'app_id':'QJT4ednyb3ber0m5g75d',
             'app_code':'QplsyvIKvVKCdN3bF8MqPQ',
             'layer_id':'1',
             'bbox':'%f,%f;%f,%f' % (float(sys.argv[1]), float(sys.argv[2]), float(sys.argv[3]), float(sys.argv[4]))}

    contentR = requests.get(https_request, params=payload)
    print(contentR.text)

main()

#https://cle.cit.api.here.com/2/search/bbox.json?app_id=QJT4ednyb3ber0m5g75d&app_code=QplsyvIKvVKCdN3bF8MqPQ&layer_id=1&bbox=-35.51813,172.37773%3B-36.51314,173.39245
