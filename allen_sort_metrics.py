##imports===============================================================================
import sys,os, inspect
sys.path.append(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe()))) + "/libraries/sorting_quality");
import sorting_quality as sq
import scipy.io as sio
from sklearn.manifold import TSNE
from scipy.cluster.vq import kmeans2

import numpy as np
import seaborn as sns
import pandas as pd
import os, csv, time
import matplotlib.pyplot as plt
##===============================================================================
def allen_sort_metrics(data_directory = '/Users/mschaff/Documents/KiloSort', output_directory = '/Users/mschaff/Documents/test', binary_file_path = '/Users/mschaff/Documents/KiloSort/Jun22_17_192ch_sr25kblock4__binary.dat'):
    #get metrics===============================================================================
    time_limits = None #select a subrange of the recording, in seconds, e.g. [500.,600.] ([start, end])
    t0 = time.time()
    #quality
    quality = sq.masked_cluster_quality(data_directory,time_limits)
    print('PCA quality took '+str(time.time()-t0)+' sec',);t0 = time.time()
    # isiV
    isiV = sq.isiViolations(data_directory,time_limits);
    cluster_groups = [np.array([], dtype=np.int64),np.array([], dtype=np.int64), isiV[0][isiV[0] > 0]];
    print('ISI quality took '+str(time.time()-t0)+' sec',);t0 = time.time()
    # signal to noise
    SN = sq.cluster_signalToNoise(data_directory,time_limits,filename=binary_file_path, no_csv=True)
    print('SN quality took '+str(time.time()-t0)+' sec',);t0 = time.time()

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

    # create new directory
    new_directory = os.path.join(output_directory, 'allen_metrics')
    if not os.path.isdir(new_directory):
        os.mkdir(new_directory)
    #save df
    a_dict = {col_name: df[col_name].values for col_name in df.columns.values}
    sio.savemat(os.path.join(new_directory, 'allen_metrics.mat'), {'struct': a_dict})


    # d=sq.neuron_fig(clusterID=34,df=df,sortpath=data_directory,filename='/Users/mschaff/Documents/KiloSort/Jun22_17_192ch_sr25kblock4__binary.dat');
    #
    # # plot ISI Purity
    # objects = ('Python', 'C++', 'Java', 'Perl', 'Scala', 'Lisp')
    # y_pos = np.arange(len(objects))
    # performance = [10, 8, 6, 4, 2, 1]
    #
    # plt.barh(y_pos, performance, align='center', alpha=0.5)
    # plt.yticks(y_pos, objects)
    # plt.xlabel('Usage')
    # plt.title('Programming language usage')
    #
    # plt.show()
    # plt.savefig('what.png')

    return 'Generated & saved Allen Brain sorting metrics.'