# wmt21_terminology
Preprocessing scripts for our submission
First, run create_corp.sh, which downloads a preprocesses the training datasets (fasttext langid, moses clean scripts, factored-segmenter)
prepare_choices.sh adds random constraints to the training data
process_test.sh converts dev sets provided by the organizers in our format
