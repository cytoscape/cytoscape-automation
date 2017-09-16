function CytoscapeObject($viewportElement, networkData){
  
  var cy, edgeCollection, nodeCollection, nodeSizeMapping;
  
  // Returns proper node width/height based on mapping in cytoscape
  // In cytoscape's control panel (left panel), click style > node > size to see mapping GUI
  // Function may be adapted for general purpose mapping, focusing on node size for now
  function getNodeSize(node){

    node_mapping = networkData.mapping;

    nodeValue = node[node_mapping.mappingColumn];

    if(nodeValue <= node_mapping.points[0].value){
      return node_mapping.points[0].value.lesser;
    }

    if(nodeValue >= node_mapping.points[node_mapping.points.length - 1].value){
      return node_mapping.points[0].value.greater;
    }

    for(var i in node_mapping.points){
      if( nodeValue == node_mapping.points[i].value ){
        return node_mapping.points[i].equal;
      }

      // If nodeValue is less than point value, its value must lie between current and previous values.
      if(nodeValue < node_mapping.points[i].value){
        return ((nodeValue - node_mapping.points[i-1].value) / 
               (node_mapping.points[i].value - node_mapping.points[i-1].value)) *
               (parseFloat(node_mapping.points[i].equal) - parseFloat(node_mapping.points[i-1].equal)) + 
               parseFloat(node_mapping.points[i-1].equal);
      }
    } 
  }

  function randomColor(){

    var letters = ['7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'],
        returnString = '#';

    function randomValue(){
      return letters[Math.floor(Math.random()*letters.length)]
    }

    for (var i = 0; i < 6; i++) { 
      returnString += randomValue();
    }

    return returnString;
  }

  // If change should be affected immediately, pass boolean true as argument for 'update' parameter
  // Otherwise, pass boolean false
  function updateEdge(selector, style, update){
    cy.style().selector(selector).style({'line-color': color});
    if(update) cy.style().update();
  }

  function updateAllNodeSizes(){
    var node, widthHeight;

    for (var i in nodeCollection) {
      node = nodeCollection[i].data
      widthHeight = getNodeSize(node);

      cy.style()
        .selector('node[id="' + node.id + '"]')
        .style({'width': widthHeight,
                'height': widthHeight });
    }

    cy.style().update();
  }

  function updateAllEdgeWidths(){

    var maxWeight = 0;

    for (var i in edgeCollection) {
      if(edgeCollection[i].data.Weight > maxWeight){
        maxWeight = edgeCollection[i].data.Weight;
      }
    }

    for (var i in edgeCollection) {

      calculatedWidth = ( edgeCollection[i].data.Weight < 0 ) ? 1 : Math.ceil(edgeCollection[i].data.Weight/maxWeight * 7);

      cy.style()
        .selector('edge[id="' + edgeCollection[i].data.id + '"]')
        .style({'width': calculatedWidth });
    }

     cy.style().update()
  }

  // Center network and zoom to appropriate level
  function centerZoom(){
    cy.zoom(cy.getFitViewport().zoom);
    cy.center(); 
  }

  function init(){
    edgeCollection = networkData.network.elements.edges;
    nodeCollection = networkData.network.elements.nodes;


    cy = cytoscape({
            container: $viewportElement, 
            style: networkData.style[0].style
          });

    if(networkData.mapping){
      updateAllNodeSizes();
    }

    updateAllEdgeWidths();
    cy.json( networkData.network );

    cy.style().update();
    centerZoom();
  }

  init();

  // Interface for CytoscapeObject.
  return {
    updateEdge: updateEdge
  }
};


function CytoscapeGUI(){
  var $colorController = $("#partialTemplates .colorController").first(),
      $colorPanel      = $("#edgeColorControlPanel"),
      edgeCollection   = cy.getEdges();

  function generateEdgeColorController(edgeType, color){
    var $controller = $colorController.clone();
        $controllerInput = $controller.find('.jscolor');
        
    $controller.find('.edgeType').html(edgeType);
    $controllerInput.css('backgroundColor', color);
    $controllerInput.val(color);
    $controllerInput.data('type', edgeType);

    return $controller;
  }

  function populateEdgeColorControl(){
    for (var edge in edgeCollection) {
      $colorPanel.append( generateEdgeColorController(edge, edgeCollection[edge]) );
    }

    jscolor.installByClassName('jscolor');
    $('.jscolor').change(updateEdgeColor);
  }

  function updateEdgeColor(){
    var $this = $(this);
    cy.updateEdgeColor($this.data('type'), '#' + $this.val(), true);
  }
  
  function init(){
    populateEdgeColorControl();
  } 

  init();
}

function formatViewport(){
  // Sets cytoscape viewport element to appropriate height

  var viewport = document.getElementById('cyViewport'),
      windowHeight = window.innerHeight; 

  viewport.style.height = windowHeight + 'px';
}  

function getData(property, number){
  for (var i = number; i > 0; i--) {
    if (property + i in CytoscapeData) {
      return CytoscapeData[property + i];
    }
  }

  return null;
}

function assembleNetworkData(number) {
  properties = ['network', 'mapping', 'style'];
  returnObject = {};

  for(var i in properties){
    returnObject[properties[i]] = getData(properties[i], number);
  }  

  return returnObject;
}

$(document).ready(function(){ 

  $('.showResults').click(function(){

    $this = $(this);

    if($this.text() == "Show Results"){
      $this.text("Hide Results");
    }else{
      $this.text("Show Results");
    }

    $("[data-viewnum=" + $this.data('viewport') + "]").slideToggle(function(){
      if($this.data('rendered')) return;

      CytoscapeObject(this, assembleNetworkData($this.data('viewport')) );
      $this.data('rendered', true);
    });
  })

})
