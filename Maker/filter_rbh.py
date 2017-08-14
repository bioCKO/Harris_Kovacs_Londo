import os
import sys
import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

os.chdir('find_unsupported_v2_models')

master = pd.read_table('unsupported_v2.1_models.len')
master.columns = ['v2_modelName', 'len']

v2_models = pd.read_table('red_v2.1_unsupported_models.gff', header=None)
v2_models.columns = ['v2_modelName', 'v2_chr']

## Augustus

augustus = pd.read_table('augustus_trial', header=None)
augustus.columns = ['v2_modelName', 'predName', 'Start_query', 'End_query', 'e_value']

augLen = augustus.merge(master, on='v2_modelName', how='left')
augLen['percent_ali'] = (augLen['End_query'] - augLen['Start_query'] + 1) / augLen['len'] * 100 
augLen.drop(['Start_query', 'End_query', 'e_value'], axis=1, inplace=True)

augChr = pd.read_table('red_augustus_models.gff', header=None)
augChr.columns = ['predName', 'pred_chr']

xx = augLen.merge(augChr, on='predName', how='left')
yy = xx.merge(v2_models, on='v2_modelName', how='left')


aug_same_chr = yy[yy['pred_chr'] == yy['v2_chr']]
aug_above90 = aug_same_chr[aug_same_chr['percent_ali'] >= 90]
aug_above90['predictor'] = 'Augustus'

print(len(aug_same_chr))
print(len(aug_above90))

##sames = []
##for i in range(100, 0, -1):
##    x = len(aug_same_chr[aug_same_chr['percent_ali'] >= i])
##    sames.append(x)
##
##plt.scatter(range(100, 0, -1), sames)
##plt.show()


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

print(len(non_same_chr))
print(len(non_above90))

##sames = []
##for i in range(100, 0, -1):
##    x = len(non_same_chr[non_same_chr['percent_ali'] >= i])
##    sames.append(x)
##
##plt.scatter(range(100, 0, -1), sames)
##plt.show()

## Snap

snap = pd.read_table('snap_trial', header=None)
snap.columns = ['v2_modelName', 'predName', 'Start_query', 'End_query', 'e_value']

snapLen = snap.merge(master, on='v2_modelName', how='left')
snapLen['percent_ali'] = (snapLen['End_query'] - snapLen['Start_query'] + 1) / snapLen['len'] * 100 
snapLen.drop(['Start_query', 'End_query', 'e_value'], axis=1, inplace=True)

snapChr = pd.read_table('red_snap_models.gff', header=None)
snapChr.columns = ['predName', 'pred_chr']

xx = snapLen.merge(snapChr, on='predName', how='left')
yy = xx.merge(v2_models, on='v2_modelName', how='left')


snap_same_chr = yy[yy['pred_chr'] == yy['v2_chr']]
snap_above90 = snap_same_chr[snap_same_chr['percent_ali'] >= 90]
snap_above90['predictor'] = 'Snap'

print(len(snap_same_chr))
print(len(snap_above90))

##sames = []
##for i in range(100, 0, -1):
##    x = len(snap_same_chr[snap_same_chr['percent_ali'] >= i])
##    sames.append(x)
##
##plt.scatter(range(100, 0, -1), sames)
##plt.show()

# Combine

frames = [aug_above90, non_above90, snap_above90]
df = pd.concat(frames)

x = df.v2_modelName.value_counts()
print(len(x[x == 3]))
print(len(x[x == 2]))
print(len(x[x == 1]))
