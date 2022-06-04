#!/usr/bin/env bash
set -e

function progress() {
    while true; do
        sleep 10
        echo ".png $(find tiles -name '*.png' | wc -l) .gz $(find tiles -name '*.gz' | wc -l) .pbf $(find tiles -name '*.pbf' | wc -l)"
    done;
}

rm -rf tiles

for f in *.mbtiles; do
    echo "${f}"
    tilelive-copy --minzoom=0 --maxzoom=14 --bounds=-73.6346,41.1055,-69.5464,42.9439 "${f}" file://./tiles
    tilelive-copy --minzoom=0 --maxzoom=4 --bounds=-180,-90,180,90 "${f}" file://./tiles
done

progress &
BACKGROUND_PID=$!
trap "kill ${BACKGROUND_PID}" EXIT

echo "moving..."
for f in $(find tiles -name '*.png'); do
    mv -- "$f" "${f%.png}.pbf.gz"
done

echo "unzipping..."
gunzip -r tiles/
