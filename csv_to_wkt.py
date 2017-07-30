#!/usr/bin/python

import csv, sys
csv.field_size_limit(sys.maxsize)

def main():
    with open("output.wkt", 'w') as wkt_file:
	wkt_file.write("meshblock_id\tshapefile\n")
        with open("mb_geo.csv", 'r') as data_file:
       	    spamreader = csv.reader(data_file)
            for row in spamreader:
                shapefile = row[0]
                meshblock_id = row[1]
                if (shapefile == "" or meshblock_id == ""):
                    print("Missing data")
                    continue
		wkt_file.write("%s\t%s\n" % (meshblock_id, shapefile))


main()
