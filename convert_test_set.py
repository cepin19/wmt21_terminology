import sys
import xml.etree.ElementTree as ET
for line in sys.stdin:
#    print(line)
    if not line.startswith("<seg"): continue
    try:
        seg=ET.fromstring(line)
    except:
        seg=ET.fromstring(line.replace(" < "," &lt; ").replace(" & "," &amp; "))
    srcLine=ET.tostring(seg, encoding='unicode', method='text')
    terms=[]
    for term in seg.iter('term'):
        terms.append(term.attrib["tgt"].replace('|',' <v> '))
    print("{} <sep> {}".format(srcLine," <c> ".join(terms)))
