
const displayCX = function (cx, elementId) {
    //Find the HTML element with the passed ID.
    const element = document.getElementById(elementId);

    //Load the network utilities and translate CX to the niceCX
    //format required for cx2js.
    const utils = new cytoscapeCx2js.CyNetworkUtils();
    const niceCX = utils.rawCXtoNiceCX(cx);
    
    //Load the cx2js converter. The network utilities instance is passed
    //along to do necessary conversions.
    const cx2Js = new cytoscapeCx2js.CxToJs(utils);

    //Create a mutable attributeNameMap. 
    //cx2js can extract different types of data from cx and this map 
    //is used to keep track of attributes whose conversion has already 
    //been performed.
    let attributeNameMap = {};

    //Convert the necessary Cytoscape.js parameters from the niceCX data. 
    const elements = cx2Js.cyElementsFromNiceCX(niceCX, attributeNameMap);
    const style = cx2Js.cyStyleFromNiceCX(niceCX, attributeNameMap);
    const cyBackgroundColor = cx2Js.cyBackgroundColorFromNiceCX(niceCX);
    const layout = cx2Js.getDefaultLayout();
    const zoom = cx2Js.cyZoomFromNiceCX(niceCX);
    const pan = cx2Js.cyPanFromNiceCX(niceCX);

    element.style.backgroundColor = cyBackgroundColor;

    //Create the Cytoscape.js parameters
    const cytoscapeJS = {
        container: element,
        style: style,
        elements: elements,
        layout: layout,
        zoom: zoom,
        pan: pan
    };

    //Initialize Cytoscape.js using our parameters.
    const cy = cytoscape(cytoscapeJS);

    //Automatically fit the contents of the graph to the enclosing HTML element.
    cy.fit()
};