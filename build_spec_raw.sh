IN=./chain-spec.json
OUT=./chain-spec-raw.json

./substrate build-spec --chain=$IN --raw > $OUT
