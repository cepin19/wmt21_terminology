usage="""
Generates random constraint subsequences from reference sentences. Version for not prerprocessed files.

Usage: cat $tab_separated_corpus | generate_random_constraints.py  $outprefix $choices_uni $choices_bi $choices_tri 

creates 2 files:
$outprefix.random_constraints -- only the constraint sequences, separated by <c>
$outprefix.random_constraints_suffix -- constraints are appended to the source sentence, separated by <sep> from the sentence and by <c> from each other
"""
import sys
import random
import nltk
import string
if len(sys.argv)!=5:
    print(usage)
    sys.exit(-1)
skip_prob=0.2 # probability of skipping the sentence entirely
start_prob=0.1 # probability of starting a new constraint on each token
## for training data above

#skip_prob=0.1
#start_prob=0.5
#for test data


end_prob=0.75 # probability of finishing the constraint on each token
variant_prob=0.3
same_len_prob=0.9
shuffle=True
stop_words=set(['la','le','de','l\'','d\''])
ngrams=[]
#load random target corpus n-grams to create "fake" choices
with open(sys.argv[2]) as unif, open(sys.argv[3]) as bif, open(sys.argv[4]) as trif:
    unigrams=unif.read().splitlines()
    bigrams=bif.read().splitlines()
    trigrams=trif.read().splitlines()
    ngrams.append(unigrams)
    ngrams.append(bigrams)
    ngrams.append(trigrams)

with open(sys.argv[1]+".random_constraints","w") as cf,  open(sys.argv[1]+".random_constraints_suffix","w") as sf:
    for line in sys.stdin:
        constraints=[]
        line_src,line_tgt=line.split('\t')
        if random.random()>skip_prob:
            cf.write("\n")
            sf.write("{} <sep>\n".format(line_src.strip()))
            continue
        line_tgt_tok=nltk.word_tokenize(line_tgt)
        constraint_open=False
        for i,tok in enumerate(line_tgt_tok):
            if not constraint_open:
                if random.random()<start_prob and tok not in string.punctuation and tok not in stop_words:
                    constraint_open=True
                    constraint_tmp=tok
                    #continue
            if constraint_open:
                if random.random()<end_prob:# and (i+1==len(line_tgt_tok) or line_tgt_tok[i+1] in string.punctuation):
                    constraint_open=False
                    if constraint_tmp!=tok:
                        constraint_tmp+=" "+tok
                    #sample multiples "fake" variants (TODO: smarter/harder neg. examples)
                    while random.random()<variant_prob:
                        if random.random()<same_len_prob:
                            l=len(constraint_tmp.strip().split(" "))
                            if l<=3:
                                variant=random.choice(ngrams[l-1]).strip()
                                while variant in line_tgt:
                                    variant=random.choice(ngrams[l-1]).strip()

                            else:
                                variant=' '.join(random.sample(ngrams[0],k=l)).strip()
                                while variant in line_tgt:
                                    variant=' '.join(random.sample(ngrams[0],k=l)).strip()


                        else:
                            variant=random.choice(ngrams[random.randint(0,2)])
                            while variant in line_tgt:
                                variant=' '.join(random.sample(ngrams[0],k=l)).strip()


                        constraint_tmp+=" <v> {}".format(variant.strip())
                    if "<v>" in constraint_tmp:
                        #print(constraint_tmp)
                        ct=constraint_tmp.split("<v>")
                        random.shuffle(ct)
                        constraint_tmp=' <v> '.join(ct)
                    constraints.append(constraint_tmp.strip())
                    constraint_tmp=""
                else:
                    if constraint_tmp!=tok:
                        constraint_tmp+=" "+tok
        if shuffle:
            random.shuffle(constraints)

        cf.write(" <c> ".join(constraints).strip()+ "\n")
        sf.write("{} <sep> {}".format(line_src.strip()," <c> ".join(constraints).strip()).strip()+'\n')


