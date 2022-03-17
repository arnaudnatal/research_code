# -*- coding: utf-8 -*-
"""
Created on Thu Mar 17 15:00:08 2022

@author: Arnaud
"""

pip install --upgrade kmodes

import numpy as np
from kmodes.kmodes import KModes

# random categorical data
data = np.random.choice(20, (100, 10))

km = KModes(n_clusters=4, init='Huang', n_init=5, verbose=1)

clusters = km.fit_predict(data)

# Print the cluster centroids
print(km.cluster_centroids_)