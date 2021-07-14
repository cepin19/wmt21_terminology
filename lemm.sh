model="/home/large/data/models/marian/constrained_beam/udpipe/french-gsd-ud-2.5-191206.udpipe"
udpipe=/home/large/data/models/marian/constrained_beam/udpipe/udpipe-1.2.0-bin/bin-linux64
#/../udpipe/udpipe-1.2f.0-bin/bin-linux64/udpipe --output horizontal --input horizontal --tokenize  $model $2
cat $1 | sed 's/^\s*$/#empty/g'  |"$udpipe"/udpipe --tagger=templates=lemmatizer --tag --input horizontal --tokenizer=presegmented --immediate   $model  | cut -f3 | grep -v ^\# | tr '\n' ' ' | sed 's/  /\n/g' | sed 's/^empty$//g' |sed 's/< c >/<c>/g' |sed 's/< ce >/<c>/g'    > $1.lemmatized

