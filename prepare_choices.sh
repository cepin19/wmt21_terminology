#/bin/bash
set -ex
segmenter=/home/big_maggie/usr/nmt_scripts/factored-segmenter/bin/Release/netcoreapp3.1/linux-x64/publish/

# extract 1- to 3- grams for "fake" choices
python generate_ngrams.py <(head -n 5000000 corp.pre.en-fr.fr.cln)

#create source side corpus with lemmatized constraint as a suffix
paste corp.pre.en-fr.en.cln corp.pre.en-fr.fr.cln.lemm | python generate_random_constraints_choices.py corp.pre.en-fr.lemm.choices fr_lemm_uni fr_lemm_bi  fr_lemm_tri

$segmenter/factored-segmenter encode  --model enfr.fsm < corp.pre.en-fr.lemm.choices.random_constraints_suffix > corp.pre.en-fr.lemm.choices.random_constraints_suffix.fs

#dev set
paste newstest15.en.snt newstest15.fr.snt.lemmatized | python generate_random_constraints_choices.py newstest15.lemm.choices fr_lemm_uni fr_lemm_bi  fr_lemm_tri

$segmenter/factored-segmenter encode  --model enfr.fsm < newstest15.lemm.choices.random_constraints_suffix > newstest15.lemm.choices.random_constraints_suffix.fs

#the same for non-lemmatized corpus
paste corp.pre.en-fr.en.cln corp.pre.en-fr.fr.cln | python generate_random_constraints_choices.py corp.pre.en-fr.sf.choices fr_sf_uni fr_sf_bi  fr_sf_tri
$segmenter/factored-segmenter encode  --model enfr.fsm < corp.pre.en-fr.sf.choices.random_constraints_suffix > corp.pre.en-fr.sf.choices.random_constraints_suffix.fs

paste newstest15.en.snt newstest15.fr.snt | python generate_random_constraints_choices.py newstest15.sf.choices fr_sf_uni fr_sf_bi  fr_sf_tri
$segmenter/factored-segmenter encode  --model enfr.fsm < newstest15.sf.choices.random_constraints_suffix > newstest15.sf.choices.random_constraints_suffix.fs


