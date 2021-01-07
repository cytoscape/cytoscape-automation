## What is _py4cytoscape_?
[py4cytoscape](https://github.com/cytoscape/py4cytoscape) is a collection of utilities for using [Cytoscape](http://www.cytoscape.org/) and [Cytoscape.js](http://js.cytoscape.org/) with Python.  The Network visualization feature is still limited in Python, but with this tool, you can access both Cytoscape and Cytoscape.js network visualization engines from your Python code!

This package is still experimental and in alpha status.
[![Build Status](https://travis-ci.org/idekerlab/py2cytoscape.svg?branch=develop)](https://travis-ci.org/idekerlab/py2cytoscape)
[![PyPI](https://img.shields.io/pypi/v/py2cytoscape.svg)](https://pypi.python.org/pypi/py2cytoscape)

### Background

![](http://cl.ly/Xk5o/cytoscape-flat-logo-orange-100.png)

Cytoscape is a [de-facto standard desktop application for network visualization in the bioinformatics community](https://scholar.google.com/scholar?hl=en&q=cytoscape).  But actually, it is a domain-independent graph visualization software for all types of network data analysis.  We want to introduce py2cytoscape, along with _cyREST_ and _Jupyter Notebook_, to the broader data science community.

## Installation

[py4cytoscape](https://github.com/cytoscape/py4cytoscape) supports Python 3 and above.

py4cytocape depends on python-igraph and optionally depends on scipy.
(We do not include scipy as a py4cytoscape prerequisite dependency.)

You can install py4cytoscape with pip.

### Mac


```shell
pip install py4cytoscape
#if you use the scipy dependent py4cytoscape method
pip install scipy
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
conda install scipy
```

### Ubuntu Linux

```shell
apt install g++ make libxml2-dev python-dev python3-dev zlib1g-dev
pip install py4cytoscape
#if you use the scipy dependent py4cytoscape method
pip install scipy
```

## Features

### cyREST Wrapper (New from 0.4.0)
[cyREST](http://apps.cytoscape.org/apps/cyrest) is a language-agnostic RESTful API for [Cytoscape 3](http://www.cytoscape.org/what_is_cytoscape.html).  Of course you can drive Cytoscape by calling raw RESTful API using [requests]() or other http client library, but with this wrapper, you can significantly reduce your lines of code.

#### Example: Creating an empty network in Cytoscape from Python

##### __Without__ py4cytoscape (raw cyREST API call)

```python
# HTTP Client for Python
import requests

# Standard JSON library
import json

# Basic Setup
PORT_NUMBER = 1234
BASE = 'http://localhost:' + str(PORT_NUMBER) + '/v1/'

# Header for posting data to the server as JSON
HEADERS = {'Content-Type': 'application/json'}

# Define dictionary of empty network
empty_network = {
        'data': {
            'name': 'I\'m empty!'
        },
        'elements': {
            'nodes':[],
            'edges':[]
        }
}

res = requests.post(BASE + 'networks?collection=My%20Collection', data=json.dumps(empty_network), headers=HEADERS)
new_network_id = res.json()['networkSUID']
print('Empty network created: SUID = ' + str(new_network_id))
```


### Embedded Visualization Widget for [Jupyter Notebook](http://jupyter.org/)

![](http://cl.ly/aexk/cyjs_widget.png)

You can use the Cytoscape.js network visualization widget in Jupyter Notebook. This is particularly useful when you share your network analysis results with others.


### Data Conversion Utilities to/from [Cytoscape.js](http://js.cytoscape.org/) JSON
Cytoscape.js JSON is one of the standard data exchange formats in the Cytoscape community.  py4cytoscape includes some graph data conversion utilities for popular graph analysis packages in Python.

Currently, the following graph objects are supported:

* [NetworkX](https://networkx.github.io/) - From / To Cytoscape.js JSON
* [igraph](http://igraph.org/python/) - From / To Cytoscape.js JSON
* [pandas DataFrame](http://pandas.pydata.org/) - To Cytoscape.js JSON

And these popular libraries will be supported soon:

* [Numpy adj. matrix](http://www.numpy.org/) (binary/weighted)
* [graph-tool](http://graph-tool.skewed.de/)
* [GraphX](https://spark.apache.org/graphx/)
* [GraphLab](https://github.com/dato-code/Dato-Core)
