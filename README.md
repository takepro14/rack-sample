# Rack sample

## Getting started

```sh
docker compose build
docker compose up
```

## Usage

```sh
# GET (index)
curl -X GET http://localhost:9292/memos

# POST (create)
curl -X POST http://localhost:9292/memos \
  -H "Content-Type: application/json" \
  -d '{"title": "First Memo", "content": "This is the first memo"}'

# GET (show)
curl -X GET http://localhost:9292/memos/1

# PUT (update)
curl -X PUT http://localhost:9292/memos/1 \
  -H "Content-Type: application/json" \
  -d '{"title": "Updated Memo", "content": "Updated content"}'

# DELETE (destroy)
curl -X DELETE http://localhost:9292/memos/1

# GET (show)
curl -X GET http://localhost:9292/memos/1
```
