set -ex
cat dev_set.lemm_constraint_suffix.detok | bash trans.sh  ../model/model.enfr.lemm.choices.random_constraints_suffix.npz.decoder.yml > lemm.out
cat dev_set.sf_constraint_suffix.detok | bash trans.sh  ../model/model.enfr.lemm.choices.random_constraints_suffix.npz.decoder.yml > sf.out
paste dev_set.src.detok /dev/null | sed 's/\t/<sep>/g'|bash trans.sh  ../model/model.enfr.lemm.choices.random_constraints_suffix.npz.decoder.yml > none.out
moses=/home/big_maggie/usr/moses20161024/mosesdecoder/

cat lemm.out |/home/big_maggie/usr/moses20161024/mosesdecoder/scripts/tokenizer/tokenizer.perl -l fr -no-escape  | $moses/scripts/recaser/truecase.perl --model /home/big_maggie/data/corp/tcs_models/truecase-model.fr > lemm.out.tok
cat sf.out | /home/big_maggie/usr/moses20161024/mosesdecoder/scripts/tokenizer/tokenizer.perl -l fr -no-escape | $moses/scripts/recaser/truecase.perl --model /home/big_maggie/data/corp/tcs_models/truecase-model.fr > sf.out.tok
cat none.out | /home/big_maggie/usr/moses20161024/mosesdecoder/scripts/tokenizer/tokenizer.perl -l fr -no-escape  | $moses/scripts/recaser/truecase.perl --model /home/big_maggie/data/corp/tcs_models/truecase-model.fr > none.out.tok


/home/big_maggie/usr/moses20161024/mosesdecoder/scripts/ems/support/wrap-xml.perl fr corp/terminology_evaluation/data/dev.en-fr.en.sgm test < lemm.out.tok > dev.en-fr.out.lemm.sgm
/home/big_maggie/usr/moses20161024/mosesdecoder/scripts/ems/support/wrap-xml.perl fr corp/terminology_evaluation/data/dev.en-fr.en.sgm test < sf.out.tok > dev.en-fr.out.sf.sgm
/home/big_maggie/usr/moses20161024/mosesdecoder/scripts/ems/support/wrap-xml.perl fr corp/terminology_evaluation/data/dev.en-fr.en.sgm test < none.out.tok > dev.en-fr.out.none.sgm



python  corp/terminology_evaluation/evaluate_term_wmt.py    --language fr     --hypothesis dev.en-fr.out.lemm.sgm    --source corp/terminology_evaluation/data/dev.en-fr.fr.sgm     --target_reference corp/terminology_evaluation/data/dev.en-fr.fr.sgm > lemm_results
python  corp/terminology_evaluation/evaluate_term_wmt.py     --language fr     --hypothesis dev.en-fr.out.sf.sgm   --source corp/terminology_evaluation/data/dev.en-fr.en.sgm     --target_reference corp/terminology_evaluation/data/dev.en-fr.fr.sgm > sf_results
python  corp/terminology_evaluation/evaluate_term_wmt.py     --language fr     --hypothesis dev.en-fr.out.none.sgm    --source corp/terminology_evaluation/data/dev.en-fr.fr.sgm     --target_reference corp/terminology_evaluation/data/dev.en-fr.fr.sgm > none_results
python  corp/terminology_evaluation/evaluate_term_wmt.py     --language fr     --hypothesis corp/terminology_evaluation/data/en-fr.dev.txt.truecased.sgm    --source corp/terminology_evaluation/data/dev.en-fr.fr.sgm     --target_reference corp/terminology_evaluation/data/dev.en-fr.fr.sgm > baseline_results

