proc=16
#split -d -n l/16 corp.pre.en-fr.fr.cln parts/corp.pre.en-fr.fr.cln.part
ls -1 parts/corp.pre.en-fr.fr.cln.part{00..16} | parallel -j $proc ./lemm.sh {}
cat parts/corp.pre.en-fr.fr.cln.part*.lemmatized  > corp.pre.en-fr.fr.cln.lemm

