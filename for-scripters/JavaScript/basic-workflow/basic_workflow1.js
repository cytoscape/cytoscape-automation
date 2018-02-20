/**
 * Basic workflow 1:
 *      Search NCBI Gene database and build Cytoscape network
 *      by sending the gene list to BioGRID via PSICQUIC.
 *
 */

var ncbi = require('bionode-ncbi');
var _ = require('underscore');
var request = require('request');
var psicquic = require('biojs-rest-psicquic');
var mitab = require('biojs-io-mitab');

var url = 'http://localhost:1234/v1/';

var EMPTY_NETWORK = {
    data: {
        name: 'empty network'
    },
    elements: {
        nodes: [],
        edges: []
    }
};


// Use BioGRID PSICQUIC service since it uses Entrez Gene ID as primary key.
var PSICQUIC_URL = 'http://tyersrest.tyerslab.com:8805/psicquic/webservices/current/search/';

// Query to be sent to NCBI Gene Database.
var query = '"Homo sapiens"[Organism] AND proteasome[Gene Ontology] AND alive[property]';


var filterResults = function (resultList) {
    var idList = [];
    _.each(resultList, function (res) {
        idList.push(res.uid);
    });
    return idList;
};


var buildNetwork = function (url, idAsList) {
    psicquic.url(url);
    psicquic.getInteractionsForIds(idAsList, {firstResult: 0, maxResults: 10000}, function (err, resp, body) {
        var interactions = mitab.parse(body);
        console.log('# of nodes = ' + interactions.nodes.length);
        console.log('# of edges = ' + interactions.links.length);
        toCytoscape(interactions);
    });
};

/**
 * Convert & post network to Cytoscape.
 *
 * @param interactions - Interaction data parsed by MITab parser.
 */
var toCytoscape = function (interactions) {
    var nodes = interactions.nodes;
    var edges = interactions.links;

    var newNetwork = EMPTY_NETWORK;
    newNetwork.data.name = query;

    _.each(nodes, function (node) {
        newNetwork.elements.nodes.push({
            data: {
                id: node.id,
                common: node.altIds[0].value
            }
        });

    });

    _.each(edges, function (edge) {
        newNetwork.elements.edges.push({
            data: {
                source: edge.source,
                target: edge.target,
                interaction: edge.intIds[0].value
            }
        });

    });
    postNetwork(newNetwork);
};

/**
 *
 * Call cyREST API to create network view.
 *
 * @param cytoscapeNetwork - Cytoscpae.js-style network object.
 *
 */
var postNetwork = function (cytoscapeNetwork) {
    var postNetworkUrl = url + 'networks/';
    var options = {
        url: postNetworkUrl,
        headers: {'Content-Type': 'application/json'},
        json: true,
        body: JSON.stringify(cytoscapeNetwork)
    };

    request.post(options, function (error, response, body) {
        if (!error && response.statusCode == 200) {
            var suid = body.networkSUID;
            // Apply layout
            request.get(url + 'apply/layouts/force-directed/' + suid, function (error, response, body) {
                if (!error && response.statusCode == 200) {
                    console.log(body);
                    request.get(url + 'apply/edgebundling/' + suid)
                }
            });

            // Aply Style
            request.get(url + 'apply/styles/default%20black/' + suid);
        } else {
            console.log('error: ' + response.statusCode);
        }
    });
};


/////////////////////////////////////////////////////////////////
// Run the workflow:
/////////////////////////////////////////////////////////////////

var resultArray = [];

ncbi.search('gene', query)
    .on('data', function (data) {
        resultArray.push(data);
    })
    .on('end', function () {
        console.log('Number of recored in NCBI Gene = ' + resultArray.length);
        buildNetwork(PSICQUIC_URL, filterResults(resultArray));
    });