BASE_PATH=./tmp/bdevux

./substrate purge-chain \
  --chain=./staging_raw.json \
  --base-path=$BASE_PATH

# rm -rf $BASE_PATH
