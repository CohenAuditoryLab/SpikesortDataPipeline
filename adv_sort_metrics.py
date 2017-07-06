##imports===============================================================================
import sys,os, inspect
sys.path.append(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe()))) + "/libraries/sorting_quality");
import sorting_quality as sq
from sklearn.manifold import TSNE
from scipy.cluster.vq import kmeans2

import numpy as np
# import seaborn as sns
import pandas as pd
import os, csv, time
import matplotlib.pyplot as plt
##===============================================================================

##get metrics===============================================================================
directory = '/Users/mschaff/Documents/KiloSort';
cluster_groups = sq.read_cluster_groups_CSV(directory)
print ('yay')
# print len(cluster_groups)
time_limits = None #select a subrange of the recording, in seconds, e.g. [500.,600.] ([start, end])

t0 = time.time()


quality = sq.masked_cluster_quality(directory,time_limits)
print('PCA quality took '+str(time.time()-t0)+' sec',);t0 = time.time()
isiV = sq.isiViolations(directory,time_limits)
print('ISI quality took '+str(time.time()-t0)+' sec',);t0 = time.time();
print len(isiV); print(isiV[0])
SN = sq.cluster_signalToNoise(directory,time_limits,filename='/Users/mschaff/Documents/KiloSort/Jun22_17_192ch_sr25kblock4__binary.dat')
print('SN quality took '+str(time.time()-t0)+' sec',);t0 = time.time()

#cluster group
cluster_groups = np.full((1, len(isiV[0])), 'good');

#put everything in dataframe
df = pd.DataFrame({
    'clusterID':isiV[0],
    'isi_purity':np.ones(len(isiV[1])) - isiV[1],
    'sn_max':SN[1],
    'sn_mean':SN[2],
    'isolation_distance':quality[1],
    'mahalanobis_contamination':np.ones(len(quality[2]))-quality[2],
    'FLDA_dprime':quality[3]*-1,
    #'cluster_group':cluster_groups,
    #'color':color,
})
print(df);