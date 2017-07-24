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
from sklearn.decomposition import PCA as sklearnPCA
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

    # run, plot & save PCA
    metrics = df.as_matrix(columns=['isi_purity',
                                    'sn_max',
                                    'sn_mean',
                                    'isolation_distance',
                                    'mahalanobis_contamination',
                                    'FLDA_dprime',
                                    ])
    metrics = np.nan_to_num(metrics)
    sklearn_pca = sklearnPCA(n_components=2)
    X_pca = sklearn_pca.fit_transform(metrics)
    # label_dict = {1: 'Setosa', 2: 'Versicolor'}
    plt.scatter(X_pca[:, 0], X_pca[:, 1])
    labels = isiV[0]
    for label, x, y in zip(labels, X_pca[:, 0], X_pca[:, 1]):
        plt.annotate(
            label,
            xy=(x, y), xytext=(-0, 0),
            textcoords='offset points', ha='right', va='bottom',
            # bbox=dict(boxstyle='round,pad=0.5', fc='yellow', alpha=0.5),
            arrowprops=dict(arrowstyle='->', connectionstyle='arc3,rad=0'),
            size=10
            )
    plt.title('PCA: Allen Metrics Projection onto the First 2 Principal Components')
    plt.xlabel('PC1; variance explained: ' + str(round(sklearn_pca.explained_variance_ratio_[0]*100,3)))
    plt.ylabel('PC2; variance explained: ' + str(round(sklearn_pca.explained_variance_ratio_[1]*100,3)));
    plt.gcf().set_size_inches(18.5, 10.5)
    plt.savefig(os.path.join(new_directory, 'allen_PCA.png'), dpi=200)
    plt.clf()
    #GRAPHS
    y_pos = np.arange(len(df.clusterID))

    # plot ISI Purity
    x_items = df.isi_purity
    plt.barh(y_pos, x_items, align='center', alpha=0.5)
    plt.yticks(y_pos, df.clusterID)
    plt.xlabel('ISI Purity'); plt.title('ISI Purity')
    plt.gcf().set_size_inches(18.5, 10.5)
    plt.savefig(os.path.join(new_directory, 'isi_purity.png'), dpi=200)
    plt.clf()
    # plot SNR Max
    x_items = df.sn_max
    plt.barh(y_pos, x_items, align='center', alpha=0.5)
    plt.yticks(y_pos, df.clusterID)
    plt.xlabel('SNR Max'); plt.title('SNR Max')
    plt.gcf().set_size_inches(18.5, 10.5)
    plt.savefig(os.path.join(new_directory, 'snr_max.png'), dpi=200)
    plt.clf()
    # plot SNR Mean
    x_items = df.sn_mean
    plt.barh(y_pos, x_items, align='center', alpha=0.5)
    plt.yticks(y_pos, df.clusterID)
    plt.xlabel('SNR Mean'); plt.title('SNR Mean')
    plt.gcf().set_size_inches(18.5, 10.5)
    plt.savefig(os.path.join(new_directory, 'snr_mean.png'), dpi=200)
    plt.clf()
    # plot isolation_distance
    x_items = df.isolation_distance
    plt.barh(y_pos, x_items, align='center', alpha=0.5)
    plt.yticks(y_pos, df.clusterID)
    plt.xlabel('Isolation Distance'); plt.title('Isolation Distance')
    plt.gcf().set_size_inches(18.5, 10.5)
    plt.savefig(os.path.join(new_directory, 'isolation_distance.png'), dpi=200)
    plt.clf()
    # plot Mahalanobis Contamination
    x_items = df.mahalanobis_contamination
    plt.barh(y_pos, x_items, align='center', alpha=0.5)
    plt.yticks(y_pos, df.clusterID)
    plt.xlabel('Mahalanobis Contamination'); plt.title('Mahalanobis Contamination')
    plt.gcf().set_size_inches(18.5, 10.5)
    plt.savefig(os.path.join(new_directory, 'mahalanobis_contamination.png'), dpi=200)
    plt.clf()
    # plot FLDA_dprime
    x_items = df.FLDA_dprime
    plt.barh(y_pos, x_items, align='center', alpha=0.5)
    plt.yticks(y_pos, df.clusterID)
    plt.xlabel('FLDA_dprime'); plt.title('FLDA_dprime')
    plt.gcf().set_size_inches(18.5, 10.5)
    plt.savefig(os.path.join(new_directory, 'FLDA_dprime.png'), dpi=200)
    return 'Generated & saved Allen Brain sorting metrics.'