#!/usr/bin/python

import requests
import sys
import json

def main():
    https_request = "https://cle.cit.api.here.com/2/layers/delete.json"

    payload={'app_id':'QJT4ednyb3ber0m5g75d',
             'app_code':'QplsyvIKvVKCdN3bF8MqPQ',
             'layer_ids':'1'}

    contentR = requests.get(https_request, params=payload)

    response = contentR.text
    print(response)

main()

#https://cle.cit.api.here.com/2/search/bbox.json?app_id=QJT4ednyb3ber0m5g75d&app_code=QplsyvIKvVKCdN3bF8MqPQ&layer_id=1&bbox=-35.51813,172.37773%3B-36.51314,173.39245
