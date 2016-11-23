Deep Learning Virtual Machine
================================
Sets up a VirtualBox VM with [Keras](https://keras.io/), [TensorFlow](https://www.tensorflow.org/) and [Theano](http://deeplearning.net/software/theano/) installed.
A [Vagrant](https://www.vagrantup.com/) file is used to set up this VM, which runs on Ubuntu 14.04.

### Getting Started
I assume you already have VirtualBox (version 5+) installed,
if you don't, please [download](https://www.virtualbox.org/wiki/Downloads) and install it.

1. [Download and install Vagrant](http://www.vagrantup.com/downloads.html) if you haven't previously done so.
2. Change into the `deep-learning-vm` directory start the VM by running:

    $ vagrant up 

3. Once the vm is up run

    $vagrant ssh 

4. Jupyter starts automatically. Open http://localhost:8100 on the host machine to see it.  
### What's Installed

- Deep Learning,
  - Keras, 1.0.5
  - TensorFlow, 0.10.0
  - Theano, 0.8.2
- Python, 3.5.2
  - H5py, 2.6.0
  - numpy, 1.11.1
  - pandas, 0.18.1
  - scipy, 0.18.1

In addition, an ~~Ipython~~ Jupyter notebook server is also installed. You can view it from the host's browser at http://localhost:8100.

### Testing Keras
This VM comes with a few notebooks (with required datasets).

If you'd prefer the obligatory *handwritten digits* example,
```bash
$ vagrant ssh
$ curl -sSL https://raw.githubusercontent.com/fchollet/keras/master/examples/mnist_mlp.py | python
```
The script above, `mnist_mlp.py`, trains a simple deep neural network on the MNIST dataset. 
If all goes well, you should see a test accuracy close to 98.40% after 20 epochs.

### Testing Theano (Optional)
Create a new notebook, and key in the following
```python
import theano
theano.test()
```
then Run. It took ~**2 hours** for the 2995 tests to run in the VM on my laptop.

