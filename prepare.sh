#!/bin/bash
apt-get install -y build-essential

git clone https://github.com/alando46/t3d.git
cd t3d

wget https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run

# disable nouveau drivers
mv ~/t3d/blacklist-nouveau.conf /usr/lib/modprobe.d/blacklist-nouveau.conf
# regenerate kernel initrd
update-initramfs -u

sh cuda_11.2.1_460.32.03_linux.run --ui=none --accept-license --disable-nouveau --no-cc-version-check --install-libglvnd

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

bash miniconda.sh -b -p $HOME/miniconda
# init conda session
eval "$(~/miniconda/bin/conda shell.bash hook)"
# reload settings
source ~/.bashrc

cd Total3DUnderstanding/
conda env create -f environment.yml
conda activate Total3D

apt-get install -y s3cmd
mv ~/s3cfg ~/.s3cfg

s3cmd get s3://vision/pix3d/train_test_data.tar.gz Total3DUnderstanding/data/pix3d/
echo "downloaded pix3d tar file..."
tar xf Total3DUnderstanding/data/pix3d/train_test_data.tar.gz -C Total3DUnderstanding/data/pix3d/

s3cmd get s3://vision/sunrgbd/sunrgbd_train_test_data.tar.gz
echo "downloaded sunrgbd tar file..."
tar xf Total3DUnderstanding/data/sunrgbd/sunrgbd_train_test_data.tar.gz -C Total3DUnderstanding/data/sunrgbd/

