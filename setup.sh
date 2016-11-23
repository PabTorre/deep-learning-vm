#!/bin/bash

################################################
# Provisions the Deep Learning Virtual Machine 
# 
# Credits :
# http://ermaker.github.io/blog/2015/09/08/get-started-with-keras-for-beginners.html
# https://github.com/ericwooley/apt-fast-vagrant-install (for apt-fast)
# https://gist.github.com/malev/2d2d76b1662e13acbbca (for miniconda)
# https://gist.github.com/davemkirk/90140b1edde8d18c8b83 (for IPython notebooks)
################################################

function mssg {
    now=$(date +"%T")
    echo "[$now] $1"
    shift
}

mssg "Provisioning the Deep Learning Virtual Machine ..."

mssg "Updating the package index files. Usually takes ~ 6 minutes, depending on the speed of your network ..."
apt-get -y update >/dev/null 2>&1


#############################################
# Add CUDA toolkit 

# add cuda first
wget -O /tmp/cuda-repo-ubuntu1410_7.0-28_amd64.deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1410/x86_64/cuda-repo-ubuntu1410_7.0-28_amd64.deb
dpkg -i /tmp/cuda-repo-ubuntu1410_7.0-28_amd64.deb 
#
apt-get install -y cuda-7-0 cuda-toolkit-7-0

################################################
# apt-fast
mssg "Installing apt-fast to try speed things up ..."
apt-get install -y aria2 --no-install-recommends >/dev/null 2>&1
filetowget=apt-fast
if [[ ! -f $filetowget ]]; then
   wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast >/dev/null 2>&1
   cp apt-fast /usr/bin/
   chmod +x /usr/bin/apt-fast
fi
filetowget=apt-fast.conf
if [[ ! -f $filetowget ]]; then
   wget https://raw.githubusercontent.com/ilikenwf/apt-fast/master/apt-fast.conf >/dev/null 2>&1
   cp apt-fast.conf /etc
fi

mssg "Installing pip ..."
apt-fast -y install python-pip >/dev/null 2>&1

################################################
# Miniconda
mssg "Downloading & Installing Miniconda ..."
miniconda=Miniconda3-4.0.5-Linux-x86_64.sh
if [[ ! -f $miniconda ]]; then
    wget --quiet http://repo.continuum.io/miniconda/$miniconda
    chmod +x $miniconda
    ./$miniconda -b -p /home/vagrant/miniconda
    echo 'export PATH="/home/vagrant/miniconda/bin:$PATH"' >> /home/vagrant/.bashrc
    source /home/vagrant/.bashrc
    chown -R vagrant:vagrant /home/vagrant/miniconda
    /home/vagrant/miniconda/bin/conda install conda-build anaconda-client anaconda-build -y -q
fi

################################################
# Essential Python packages : pandas, scikit-learn
mssg "Installing pandas, scikit-learn"
/home/vagrant/miniconda/bin/conda install "pandas==0.18.1" -y -q
/home/vagrant/miniconda/bin/conda install "scikit-learn==0.18" -y -q

################################################
# Theano, H5py, Keras
mssg "Installing Theano dependencies"
apt-fast install -y python3-numpy python3-scipy python3-dev python3-pip python3-nose g++ libopenblas-dev git >/dev/null 2>&1
/home/vagrant/miniconda/bin/pip install nose
/home/vagrant/miniconda/bin/pip install nose_parameterized
mssg "Installing Theano"
/home/vagrant/miniconda/bin/pip install "Theano==0.8.2"

mssg "Installing H5py"
apt-fast install -y libhdf5-dev >/dev/null 2>&1
/home/vagrant/miniconda/bin/pip install "h5py==2.6.0" >/dev/null 2>&1

mssg "Installing Keras"
/home/vagrant/miniconda/bin/pip install "keras==1.0.5" >/dev/null 2>&1

mssg "Installing Tensorflow"
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.10.0-cp35-cp35m-linux_x86_64.whl
/home/vagrant/miniconda/bin/pip install $TF_BINARY_URL >/dev/null 2>&1

################################################
# Other Python packages
/home/vagrant/miniconda/bin/pip install --verbose -r /home/vagrant/requirements.txt

################################################
mssg "Installing IPython Notebook server"
mkdir -p /home/vagrant/notebooks
chown -R vagrant:vagrant /home/vagrant/notebooks
/home/vagrant/miniconda/bin/pip install ipython[notebook]

################################################
mssg "Downloading a few datasets to get started with some of the IPython Notebooks"
mkdir -p /home/vagrant/datasets/uci
wget http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data -O /home/vagrant/datasets/uci/pima-indians-diabetes.csv -nv
chown vagrant:vagrant /home/vagrant/datasets -R

echo ""
mssg "List of installed packages"
/home/vagrant/miniconda/bin/pip list

mssg "Set the timezone"
echo 'Asia/Singapore' | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

mssg "Done!"
