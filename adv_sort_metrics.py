##imports===============================================================================
import sys,os, inspect
sys.path.append(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe()))) + "/libraries/sorting_quality");
import sorting_quality as sq
from sklearn.manifold import TSNE
from scipy.cluster.vq import kmeans2

import numpy as np
import seaborn as sns
import pandas as pd
import os, csv, time
import matplotlib.pyplot as plt
##===============================================================================

##get metrics===============================================================================
directory = '/Users/mschaff/Documents/KiloSort';
cluster_groups = sq.read_cluster_groups_CSV(directory)
print (cluster_groups)
# print len(cluster_groups)
time_limits = None #select a subrange of the recording, in seconds, e.g. [500.,600.] ([start, end])

t0 = time.time()


quality = sq.masked_cluster_quality(directory,time_limits)
print('PCA quality took '+str(time.time()-t0)+' sec',);t0 = time.time()
isiV = sq.isiViolations(directory,time_limits);
cluster_groups = [np.array([], dtype=np.int64),np.array([], dtype=np.int64), isiV[0][isiV[0] > 0]];
print('ISI quality took '+str(time.time()-t0)+' sec',);t0 = time.time();
print len(isiV); print(isiV[0])
SN = sq.cluster_signalToNoise(directory,time_limits,filename='/Users/mschaff/Documents/KiloSort/Jun22_17_192ch_sr25kblock4__binary.dat', no_csv=True)
print('SN quality took '+str(time.time()-t0)+' sec',);t0 = time.time()

#cluster group
#cluster_groups = np.full((1, len(isiV[0])), 'good');

cluster_group = []
color = []
for clu_id in isiV[0]:
    if clu_id in cluster_groups[0]:
        cluster_group.append('good')
        color.append(sns.color_palette()[1])
    else:
        if clu_id in cluster_groups[1]:
            cluster_group.append('mua')
            color.append(sns.color_palette()[0])
        else:
            if clu_id in cluster_groups[2]:
                cluster_group.append('unsorted')
                color.append(sns.color_palette()[0])
            else:
                cluster_group.append('noise')
                color.append(sns.color_palette()[0])

#put everything in dataframe
df = pd.DataFrame({
    'clusterID':isiV[0],
    'isi_purity':np.ones(len(isiV[1])) - isiV[1],
    'sn_max':SN[1],
    'sn_mean':SN[2],
    'isolation_distance':quality[1],
    'mahalanobis_contamination':np.ones(len(quality[2]))-quality[2],
    'FLDA_dprime':quality[3]*-1,
    'cluster_group':cluster_group,
    'color':color,
})
print(df);