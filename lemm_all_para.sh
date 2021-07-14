proc=32
split -d -n l/32 corp+paracrawl.pre.en-fr.fr.cln parts/corp+paracrawl.pre.en-fr.fr.cln.part
ls -1 parts/corp+paracrawl.pre.en-fr.fr.cln.part{00..31} | parallel -j $proc ./lemm.sh {}
cat parts/corp+paracrawl.pre.en-fr.fr.cln.part*.lemmatized  > corp+paracrawl.pre.en-fr.fr.cln.lemm

