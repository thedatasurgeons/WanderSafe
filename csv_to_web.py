#!/usr/bin/python

import csv, sys
import os
import requests

csv.field_size_limit(sys.maxsize)

def main():
    with open("canterbury_meshblocks.csv", 'r') as filter_file:
        filter = []

        spamreader = csv.reader(filter_file)
        for row in spamreader:
            filter.append(str(row[0]))

        #print filter

    print("Filter has been created! Size=%i" % len(filter))

    with open("mb_geo.csv", 'r') as data_file:
        spamreader = csv.reader(data_file)

        # Get first row out and spam it gone
        next(spamreader, None)

        writebuf = []

        for row in spamreader:
            # Check to see if mesh block ID is in Canterbury before writing to file
            meshblock_id_to_write=str(row[1])
            #print meshblock_id_to_write
            if meshblock_id_to_write in filter:
                #print("Writing meshblock %s to buffer" % meshblock_id_to_write)
                writebuf.append(row)

            print(len(writebuf))

            if len(writebuf) < 5678:
                continue

            with open("tmp.wkt", 'w') as tmp_file:
                tmp_file.write("MB2017;*\tWKT\n")
                for item in writebuf:
                    shapefile=item[0]
                    meshblock_id=item[1]
                    if shapefile is None:
                        print("Shapefile has no data!")
                        continue
                    if meshblock_id is None:
                        print("meshblock_id is empty!")
                        continue

                    tmp_file.write("%s\t%s\n" % (meshblock_id, shapefile))

            writebuf = []

            # Send file to Here
            https_request = "https://cle.cit.api.here.com/2/layers/upload.json"
            payload={'app_id':'QJT4ednyb3ber0m5g75d',
                     'app_code':'QplsyvIKvVKCdN3bF8MqPQ',
                     'layer_id':'1'}

            files = {'file.wkt': open('tmp.wkt', 'rb')}
            print("Doing the request")
            contentR = requests.post(https_request, files=files, params=payload)
            print(contentR.content)

main()
