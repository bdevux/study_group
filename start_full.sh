NODE_NAME='SAMPLE'
BASE_PATH=./tmp/bdevux

./substrate \
  --chain=./staging_raw.json \
  --bootnodes=/ip4/52.197.199.13/tcp/30333/p2p/QmaJKELVSebfXRLWPrJpizA5WSfXrheDC8wdGD7azSCeMg \
  --base-path=$BASE_PATH \
  --name=$NODE_NAME \
  --telemetry-url ws://telemetry.polkadot.io:1024
