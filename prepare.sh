#!/bin/bash
apt-get install -y build-essential

git clone https://github.com/alando46/t3d.git
cd t3d

wget https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_460.32.03_linux.run

# disable nouveau drivers
cp ~/t3d/blacklist-nouveau.conf /usr/lib/modprobe.d/blacklist-nouveau.conf
# regenerate kernel initrd
update-initramfs -u

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/t3d/miniconda.sh

bash ~/t3d/miniconda.sh -b -p $HOME/t3d/miniconda

# init conda session
eval "$(~/t3d/miniconda/bin/conda shell.bash hook)"
# reload settings
source ~/.bashrc

cd Total3DUnderstanding/
conda env create -f environment.yml
conda activate Total3D

apt-get install -y s3cmd

s3cmd get s3://vision/pix3d/train_test_data.tar.gz ~/t3d/Total3DUnderstanding/data/pix3d/
echo "downloaded pix3d tar file..."
tar xf ~/t3d/Total3DUnderstanding/data/pix3d/train_test_data.tar.gz -C ~/t3d/Total3DUnderstanding/data/pix3d/

s3cmd get s3://vision/sunrgbd/sunrgbd_train_test_data.tar.gz ~/t3d/Total3DUnderstanding/data/sunrgbd/
echo "downloaded sunrgbd tar file..."
tar xf ~/t3d/Total3DUnderstanding/data/sunrgbd/sunrgbd_train_test_data.tar.gz -C ~/t3d/Total3DUnderstanding/data/sunrgbd/

