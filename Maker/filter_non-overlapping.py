import os
import sys
import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

os.chdir('find_unsupported_v2_models')

master = pd.read_table('unsupported_v2.1_models.len')
master.columns = ['v2_modelName', 'len']

v2_models = pd.read_table('red_v2.1_unsupported_models_rmRandom.gff', header=None)
v2_models.columns = ['v2_modelName', 'v2_chr']

## Non_overlapping

non_over = pd.read_table('non_overlapping_trial', header=None)
non_over.columns = ['v2_modelName', 'predName', 'Start_query', 'End_query', 'e_value']

nonLen = non_over.merge(master, on='v2_modelName', how='left')
nonLen['percent_ali'] = (nonLen['End_query'] - nonLen['Start_query'] + 1) / nonLen['len'] * 100
nonLen.drop(['Start_query', 'End_query', 'e_value'], axis=1, inplace=True)

nonChr = pd.read_table('red_non_overlapping_models.gff', header=None)
nonChr.columns = ['predName', 'pred_chr']

xx = nonLen.merge(nonChr, on='predName', how='left')
yy = xx.merge(v2_models, on='v2_modelName', how='left')


non_same_chr = yy[yy['pred_chr'] == yy['v2_chr']]
non_above90 = non_same_chr[non_same_chr['percent_ali'] >= 90]
non_above90['predictor'] = 'Non_overlapping'

print(len(yy))
print(len(non_same_chr))
print(len(non_above90))

x = yy[yy['pred_chr'] != yy['v2_chr']]

y = x[(x['v2_chr'] == 'chrUkn') | (x['pred_chr'] == 'chrUkn')]
print(len(y))


z = x[(x['v2_chr'] != 'chrUkn') & (x['pred_chr'] != 'chrUkn')]
print(z.head())
