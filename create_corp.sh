#!/bin/bash
set -ex

segmenter=/home/big_maggie/usr/nmt_scripts/factored-segmenter/bin/Release/netcoreapp3.1/linux-x64/publish/

#download

#paracrawl
wget https://s3.amazonaws.com/web-language-models/paracrawl/release7.1/en-fr.txt.gz

wget http://data.statmt.org/news-commentary/v16/training/news-commentary-v16.en-fr.tsv.gz

wget http://statmt.org/wmt13/training-parallel-commoncrawl.tgz

wget http://statmt.org/wmt10/training-giga-fren.tar

wget http://www.statmt.org/europarl/v10/training/europarl-v10.fr-en.tsv.gz

#UN has to be downloaded manually from: https://conferences.unite.un.org/UNCORPUS/en/DownloadOverview

gzip -d en-fr.txt.gz #paracrawl
gzip -d news-commentary-v16.en-fr.tsv.gz
gzip -d europarl-v10.fr-en.tsv.gz

tar -xf training-giga-fren.tar

cut -f1 europarl-v10.fr-en.tsv > europarl-v10.fr-en.fr
cut -f2 europarl-v10.fr-en.tsv > europarl-v10.fr-en.en

cut -f1 news-commentary-v16.en-fr.tsv > news-commentary-v16.en-fr.en
cut -f2 news-commentary-v16.en-fr.tsv > news-commentary-v16.en-fr.fr

cut -f1 en-fr.txt > paracrawl.en.snt
cut -f2 en-fr.txt > paracrawl.fr.snt


cat europarl-v10.fr-en.fr news-commentary-v16.en-fr.fr commoncrawl.fr-en.fr UNv1.0.en-fr.fr giga-fren.release2.fixed.fr > corp.fr
cat europarl-v10.fr-en.en news-commentary-v16.en-fr.en commoncrawl.fr-en.en UNv1.0.en-fr.en giga-fren.release2.fixed.fr > corp.en

cat corp.en paracrawl.en.snt > corp+paracrawl.en
cat corp.fr paracrawl.fr.snt > corp+paracrawl.fr

# just some filtering (length and language)
bash /home/big_maggie/usr/nmt_scripts/preprocess_fast_snt.sh corp+paracrawl.en corp+paracrawl.fr en en fr fr corp+paracrawl.pre
bash /home/big_maggie/usr/nmt_scripts/preprocess_fast_snt.sh corp.en corp.fr en en fr fr corp.pre


#feel free to replace with sentencepiece
cat corp.pre.en-fr.en.cln corp.pre.en-fr.fr.cln | shuf | head -n 11000000 > tmp # because of memory
env LC_ALL=en_US.UTF-8 $segmenter/factored-segmenter  train --model enfr.fsm \
      -v vocab.fsv  \
     --min-piece-count 38  --min-char-count 1  --vocab-size 32000 --single-letter-case-factors  --serialize-indices-and-unrepresentables \
      tmp

$segmenter/factored-segmenter encode  --model enfr.fsm < corp.pre.en-fr.en.cln > corp.pre.en-fr.en.fs
$segmenter/factored-segmenter encode  --model enfr.fsm < corp.pre.en-fr.fr.cln > corp.pre.en-fr.fr.fs
$segmenter/factored-segmenter encode  --model enfr.fsm < corp+paracrawl.pre.en-fr.en.cln > corp+paracrawl.pre.en-fr.en.fs
$segmenter/factored-segmenter encode  --model enfr.fsm < corp+paracrawl.pre.en-fr.fr.cln > corp+paracrawl.pre.en-fr.fr.fs



# lemmatize target sides

bash lemm_all.sh
bash lemm_all_para.sh

