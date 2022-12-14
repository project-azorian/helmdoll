#!/bin/bash
set -x

# build the 'fragile' chart and package it within the 'robust' wrapper chart.
helm package fragile
rm -fv ./robust/files/fragile-0.1.0.tgz
mv -v fragile-0.1.0.tgz ./robust/files/


helm upgrade --install --wait fragile ./fragile

# install the 'robust' wrapper chart, which in turn deploys the 'fragile' chart
helm upgrade --install --wait robust ./robust

helm status fragile

# remove the 'robust' release, and validate that the 'fragile' release still exists
helm delete robust
helm status fragile

# re-install the 'robust' release, and note that the fragile release revision has incremented again
helm upgrade --install --wait robust ./robust
helm status fragile



# update 'robust' release, and note that the fragile release revision has incremented again
helm upgrade --install --wait robust ./robust --set project_replicas=4
helm status fragile