#!/usr/bin/env python3
# scripts/merge_quran.py
# Downloads semarketir/quranjson and merges Arabic+English translation into assets/data/quran.json
import os, json, subprocess, sys
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
SRC_DIR = BASE / 'sources'
SRC_DIR.mkdir(exist_ok=True)
REPO = 'https://github.com/semarketir/quranjson.git'
repo_dir = SRC_DIR / 'quranjson'

if repo_dir.exists():
    subprocess.check_call(['git','-C',str(repo_dir),'pull'])
else:
    subprocess.check_call(['git','clone',REPO,str(repo_dir)])

# arabic file
arabic_file = repo_dir/'source'/'quran.json'
english_file = repo_dir/'source'/'en.pickthall.json'
if not arabic_file.exists():
    print('Arabic source not found'); sys.exit(1)
if not english_file.exists():
    print('English translation not found'); sys.exit(1)

with open(arabic_file,'r',encoding='utf-8') as f:
    arabic=json.load(f)
with open(english_file,'r',encoding='utf-8') as f:
    english=json.load(f)

out={'surahs':[]}
for surah in arabic['quran']['surahs']['sura']:
    num=int(surah['@index'])
    name=surah['@name']
    ayahs=[]
    for ayah in surah['aya']:
        anum=int(ayah['@index'])
        text_ar=ayah['@text']
        text_en = ''
        try:
            text_en = english['quran']['sura'][num-1]['aya'][anum-1]['@text']
        except Exception:
            pass
        ayahs.append({'number':anum,'arabic':text_ar,'english':text_en,'urdu':''})
    out['surahs'].append({'number':num,'name':name,'ayahs':ayahs})

target=BASE/'assets'/'data'/'quran.json'
with open(target,'w',encoding='utf-8') as f: json.dump(out,f,ensure_ascii=False,indent=2)
print('Wrote',target)
