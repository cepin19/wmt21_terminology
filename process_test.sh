#/bin/bash
# convert annontated dev set source side into my format 
set -ex
segmenter=/home/big_maggie/usr/nmt_scripts/factored-segmenter/bin/Release/netcoreapp3.1/linux-x64/publish/
moses=/home/big_maggie/usr/moses20161024/mosesdecoder/
cat terminology_evaluation/data/dev.en-fr.en.sgm | python convert_test_set.py  > dev_set.sf_constraint_suffix
sed 's/.*<sep>//g' dev_set.sf_constraint_suffix  >  dev_set.sf_constraints
sed 's/<sep>.*//g' dev_set.sf_constraint_suffix > dev_set.src
bash lemm.sh dev_set.sf_constraints 
mv dev_set.sf_constraints.lemmatized dev_set.lemm_constraints
paste dev_set.src dev_set.lemm_constraints | sed 's/\t/ <sep> /' > dev_set.lemm_constraint_suffix
$moses/scripts/tokenizer/detokenizer.perl -l fr < dev_set.lemm_constraint_suffix | $moses/scripts/recaser/detruecase.perl > dev_set.lemm_constraint_suffix.detok
$moses/scripts/tokenizer/detokenizer.perl -l fr < dev_set.src | $moses/scripts/recaser/detruecase.perl > dev_set.src.detok
$moses/scripts/tokenizer/detokenizer.perl -l fr < dev_set.sf_constraint_suffix | $moses/scripts/recaser/detruecase.perl > dev_set.sf_constraint_suffix.detok
$segmenter/factored-segmenter encode  --model enfr.fsm dev_set.lemm_constraint_suffix > dev_set.lemm_constraint_suffix.fs 
$segmenter/factored-segmenter encode  --model enfr.fsm dev_set.sf_constraint_suffix > dev_set.sf_constraint_suffix.fs

