package main

import (
	"encoding/csv"
	"flag"
	"log"
	"os"
	"time"

	"github.com/spkg/bom"
)

func parseDate(d string) string {
	// The original data set contains no fewer than 3 different layouts. None of
	// these are typical internet layouts for time. Change this by parsing them
	// and then converting the layout to RFC 3339.
	layouts := []string{
		"1/2/2006 15:04",
		"1/2/06 15:04",
		"2006-01-02T15:04:05",
	}

	for _, l := range layouts {
		t, err := time.Parse(l, d)
		if err == nil {
			return t.Format(time.RFC3339)
		}
	}

	log.Fatalf("Could not parse date: %s", d)
	return "" // Unreachable
}

func normalize(fields []string) []string {
	province := fields[0]
	country := fields[1]
	lastUpdate := parseDate(fields[2])
	confirmed := fields[3]
	deaths := fields[4]
	recovered := fields[5]

	var lat, lng string
	if len(fields) > 6 {
		lat = fields[6]
		lng = fields[7]
	} else {
		lat = ""
		lng = ""
	}
	var r []string
	r = append(r, province, country, lastUpdate, confirmed, deaths, recovered, lat, lng)
	return r
}

func main() {
	in := flag.String("in", "", "File to read")
	out := flag.String("out", "", "File to write")
	flag.Parse()

	if *in == "" || *out == "" {
		log.Fatal("Must supply both flags of in and out")
	}

	inFile, err := os.Open(*in)
	if err != nil {
		log.Fatalf("Error while opening file: %v", err)
	}
	defer inFile.Close()

	// There are CSV files with BOMs, so clean them up
	clean := bom.NewReader(inFile)
	r := csv.NewReader(clean)
	r.TrimLeadingSpace = true

	records, err := r.ReadAll()
	if err != nil {
		log.Fatalf("Could not parse CSV file: %v", err)
	}

	outFile, err := os.Create(*out)
	if err != nil {
		log.Fatalf("Could not open out for writing: %v", err)
	}
	defer outFile.Close()

	w := csv.NewWriter(outFile)
	defer w.Flush()

	// Header
	header := []string{
		"Province/State",
		"Country/Region",
		"Last Update",
		"Confirmed",
		"Deaths",
		"Recovered",
		"Latitude",
		"Longitude",
	}
	w.Write(header)
	records = records[1:]

	for i := range records {
		res := normalize(records[i])
		w.Write(res)
	}
}
