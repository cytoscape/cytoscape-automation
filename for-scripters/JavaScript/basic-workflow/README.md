# cyREST Examples for Node.js

![](http://cl.ly/XohP/logo300.png)
![](http://www.olindata.com/sites/default/files/nodelogo_big_2.png)

## Introduction
This is a repository of sample scripts to automate workflow using [cyRest](https://github.com/keiono/cy-rest) and node.js. 


### Requirements
* Node.js
* Latest version of cyREST
* Cytoscpae 3.1.1 and later

#### Install Dependencies
```
npm install
```

## Basic Workflows

### 1. Build a Network from NCBI Gene Database Search Result
[This](https://github.com/idekerlab/cy-rest-node/blob/master/basic_workflow1.js) is a simple workflow to do the following:

1. Send query to [NCBI Gene] database by [bionode-ncbi](https://github.com/bionode/bionode-ncbi) module.
1. From the result, extract Entrez gene ID.
1. Send the list of genes to BioGIRD via [BioJS PSICQUIC](https://github.com/jmVillaveces/biojs-rest-psicquic) client.
1. Convert the list of interactions into Cytoscape.js compatible JSON.
1. Send it to Cytoscape via cyREST
1. Apply layout, edge bundling, and Visual Style.

 The following is the result by sending this query to NCBI Gene:
 
 ```
"Homo sapiens"[Organism] AND proteasome[Gene Ontology] AND alive[property]
 ```

![](http://cl.ly/Xp5n/node_out1.png)

You can play with some other queries.  Note that if the returned list of the genes is too big, BioGRID may return empty result. 


### 2. Streaming results from multiple web services
(This repo is still under construction.  More coming soon...)


## Advanced Workflows
