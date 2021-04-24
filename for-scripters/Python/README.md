## What is _py4cytoscape_?
[py4cytoscape](https://github.com/cytoscape/py4cytoscape) is a collection of utilities for using [Cytoscape](http://www.cytoscape.org/) and [Cytoscape.js](http://js.cytoscape.org/) with Python.  The Network visualization feature is still limited in Python, but with this tool, you can access both Cytoscape and Cytoscape.js network visualization engines from your Python code!

This package is still experimental and in alpha status.
[![Build Status](https://travis-ci.org/idekerlab/py2cytoscape.svg?branch=develop)](https://travis-ci.org/idekerlab/py2cytoscape)
[![PyPI](https://img.shields.io/pypi/v/py2cytoscape.svg)](https://pypi.python.org/pypi/py2cytoscape)

### Background

![](http://cl.ly/Xk5o/cytoscape-flat-logo-orange-100.png)

Cytoscape is a [de-facto standard desktop application for network visualization in the bioinformatics community](https://scholar.google.com/scholar?hl=en&q=cytoscape).  But actually, it is a domain-independent graph visualization software for all types of network data analysis.  We want to introduce py4cytoscape, along with _cyREST_ and _Jupyter Notebook_, to the broader data science community.

## Installation

[py4cytoscape](https://github.com/cytoscape/py4cytoscape) supports Python 3.

You can install py4cytoscape with pip.

### Mac


```shell
pip install py4cytoscape
```

### Windows

To install py4cytoscape dependencies, we recommend that you use the [Miniconda](http://conda.pydata.org/miniconda.html) Python package manager.

Miniconda has a scipy binary package, but does not have a python-igraph binary package.
So download the python-igraph whl for your Python (3, 32bit or 64bit) from [Christoph’s site](http://www.lfd.uci.edu/~gohlke/pythonlibs/#python-igraph).
And install it with `pip`.
Please install python-igraph before you install py4cytoscape, otherwise pip will try to **build** python-igraph (and will fail). 

(In the case of Python 3.5 64bit)

```
pip install .\python_igraph-0.7.1.post6-cp35-none-win_amd64.whl
pip install py4cytoscape
```

### Ubuntu Linux

```shell
apt install g++ make libxml2-dev python-dev python3-dev zlib1g-dev
pip install py4cytoscape
```

## Source code for py4cytoscape

https://github.com/cytoscape/py4cytoscape

## Basic tutorials

https://py4cytoscape.readthedocs.io/en/latest/tutorials/index.html

## Cytoscape automation in Python

https://github.com/cytoscape/cytoscape-automation/wiki
