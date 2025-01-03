import csv
from collections import deque
import elasticsearch
from elasticsearch import helpers


def read_movies():
    csvfile = open('./raw-data/movies.csv', 'r', encoding="utf8")

    reader = csv.DictReader(csvfile)

    for line in reader:
        print(line)
        movie = {
            'title': line['title']
        }
        yield movie


es = elasticsearch.Elasticsearch(["http://127.0.0.1:9200"])

es.indices.delete(index="movies", ignore=404)
deque(helpers.parallel_bulk(es, read_movies(), index="movies", request_timeout=300), maxlen=0)
es.indices.refresh()
