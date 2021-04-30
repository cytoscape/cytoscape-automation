# Cytoscape Automation Overview

Visit [automation.cytoscape.org](http://automation.cytoscape.org) for a curated set of automation examples.

## What is Cytoscape Automation
Cytoscape is a desktop-based tool that focuses on user-initiated operations for generating user-consumable results. **Cytoscape Automation** enables users to create workflows executed entirely within Cytoscape or by external tools (e.g., Jupyter, R, GenomeSpace, etc), and whose results are reproducible. This enables Cytoscape to scale to large collections of datasets and to larger more complex workflows than is practical via keyboard and mouse.

Cytoscape Automation exists in two skins – the *Commands* interface and the *Functions* interface. Both can accomplish similar results, but are focused on different usage styles. Commands reprise user-initiated interactions (e.g., open session, import data, export image), whereas the Functions interface enables programmers to manipulate and operate on networks as internal Cytoscape data. Both Commands and Functions are available via a REST interface.

To learn more about Cytoscape Automation, visit our [FAQ](https://docs.google.com/document/d/1QTrT-9ylhI4OX5DkauMo2ujLIqeg3WDUDwl77KLtfVY/edit).

Also see our repo directories for [Script Writers](for-scripters) and for [App Developers](for-app-developers).

## Experimental

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cytoscape/cytoscape-automation/master?urlpath=rstudio) (for R)

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cytoscape/cytoscape-automation/master?urlpath=lab/tree/for-scripters/Python) (for Python)

[![CircleCI](https://circleci.com/gh/cytoscape/cytoscape-automation.svg?style=svg)](https://circleci.com/gh/cytoscape/cytoscape-automation) (for R)

### How to use the Binder environments
- Launch RStudio or JupyterLab server by clicking the above Binder badges.
- Run the following command in the RStudio `Terminal` tab or JupyterLab `Terminal`. This command launches Cytoscape Desktop in the background. The Cytoscape window is never visible.
  ```
  xvfb-run bash ~/cytoscape-unix-3.7.2/cytoscape.sh
  ```
- Open .Rmd or .ipynb file with RStudio or JupyterLab and run the code chunks or cells. Feel free to modify any of the scripts and run commands directly, but note that your changes will *not* be saved. *Binder only provides a temporary space to try out R and Python automation with Cytoscape.*
