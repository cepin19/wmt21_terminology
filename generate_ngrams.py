from nltk.util import ngrams 
import sys
from nltk.tokenize import word_tokenize
prefix="fr_sf_"    
with open(sys.argv[1], "r") as f:
    text = f.read()

tokenized=word_tokenize(text)
bigrams = ngrams(tokenized, 2)
trigrams = ngrams(tokenized, 3)
unigrams = ngrams(tokenized, 1)
unigrams=[' '.join(t) for t in unigrams]
bigrams=[' '.join(t) for t in bigrams]
trigrams=[' '.join(t) for t in trigrams]

with open(prefix+"uni","w") as uni, open(prefix+"bi","w") as bi, open(prefix+"tri","w") as tri:
    uni.write('\n'.join(unigrams))
    bi.write('\n'.join(bigrams))
    tri.write('\n'.join(trigrams))


