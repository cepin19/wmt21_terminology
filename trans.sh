marian=/home/big_maggie/usr/marian_prometheus/marian_1.10.0/marian-dev/build/

/home/big_maggie/usr/nmt_scripts/factored-segmenter/bin/Release/netcoreapp3.1/linux-x64/publish//factored-segmenter encode  --model corp/enfr.fsm | $marian/marian-decoder -c $1 "${@:2}" | /home/big_maggie/usr/nmt_scripts/factored-segmenter/bin/Release/netcoreapp3.1/linux-x64/publish//factored-segmenter decode  --model corp/enfr.fsm


