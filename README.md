# Cytoscape Automation Overview

Visit [automation.cytoscape.org](http://automation.cytoscape.org) for a curated set of automation examples.

The table below is the highlights of automation examples.

## Cytoscape GUI tutorials and its automation using R or Python

| GUI tutorial (reveal.js) | R notebook (R Markdown) | Python notebook (Jupyter Notebook) |
| --- | --- | --- |
| [Affinity Purification-Mass Spectrometry Network Analysis](https://cytoscape.org/cytoscape-tutorials/protocols/AP-MS-network-analysis/#/) | [link](http://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/AP-MS-network-analysis.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/affinity-purification-mass-spectrometry.ipynb) |
| [Variant Data Analysis](https://cytoscape.org/cytoscape-tutorials/protocols/variant-data-analysis/#/) | [link](http://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/Cancer-networks-and-data.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/advanced-cancer-networks-and-data.ipynb) |
| [Differentially expressed genes](https://cytoscape.org/cytoscape-tutorials/protocols/differentially-expressed-genes/#/) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/R/notebooks/Differentially-expressed-genes.Rmd) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/differentially-expressed-genes-network-analysis.ipynb) |
| [WikiPathways App](https://cytoscape.github.io/cytoscape-tutorials/protocols/wikipathways-app/#/) | [link](https://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/rWikiPathways-and-RCy3.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/wikiPathways-and-py4cytoscape.ipynb) |
| [Basic data visualization](https://cytoscape.github.io/cytoscape-tutorials/protocols/basic-data-visualization/#/) | [link](https://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/basic-data-visualization.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/basic-data-visualization.ipynb) |
| [Filtering by Selection](https://cytoscape.github.io/cytoscape-tutorials/protocols/filtering-by-selection/#/) | [link](http://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/Filtering-Networks.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/filtering-networks.ipynb) |
| [Identifier mapping](https://cytoscape.org/cytoscape-tutorials/protocols/identifier-mapping/#/) | [link](http://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/Identifier-mapping.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/identifier-mapping.ipynb) |
| [Import network from table](https://cytoscape.org/cytoscape-tutorials/protocols/importing-network-from-table/#/) | [link](http://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/ImportNetworkFromTable.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/importing-network-from-table.ipynb) |
| [Importing data from table](https://cytoscape.org/cytoscape-tutorials/protocols/importing-data-from-tables/#/) | [link](http://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/Importing-data.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/importing-data-from-tables.ipynb) |
| [Loading networks](https://cytoscape.org/cytoscape-tutorials/protocols/loading-networks/#/) | [link](https://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/loading-networks.nb.html) | [link](https://github.com/cytoscape/cytoscape-automation/blob/master/for-scripters/Python/loading-networks.ipynb) |

## What is Cytoscape Automation
Cytoscape is a desktop-based tool that focuses on user-initiated operations for generating user-consumable results. **Cytoscape Automation** enables users to create workflows executed entirely within Cytoscape or by external tools (e.g., Jupyter, R, GenomeSpace, etc), and whose results are reproducible. This enables Cytoscape to scale to large collections of datasets and to larger more complex workflows than is practical via keyboard and mouse.

Cytoscape Automation exists in two skins – the *Commands* interface and the *Functions* interface. Both can accomplish similar results, but are focused on different usage styles. Commands reprise user-initiated interactions (e.g., open session, import data, export image), whereas the Functions interface enables programmers to manipulate and operate on networks as internal Cytoscape data. Both Commands and Functions are available via a REST interface.

To learn more about Cytoscape Automation, visit our [FAQ](https://docs.google.com/document/d/1QTrT-9ylhI4OX5DkauMo2ujLIqeg3WDUDwl77KLtfVY/edit).

Also see our repo directories for [Script Writers](for-scripters) and for [App Developers](for-app-developers).

```Note to repository maintainers: Please *DO NOT* move this page ... the Cytoscape Automation paper refers directly to it.```
