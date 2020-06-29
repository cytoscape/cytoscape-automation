
let ndex = new NDEx('http://dev.ndexbio.org/v2');

ndex.getStatus().then((status)=> {console.log(status);});

ndex.setBasicAuth('cj1', 'aaaaaaaaa');

ndex.getRawNetwork('2977ee7f-1d34-11e7-8145-06832d634f41')
  .then((network) => { console.log(network);});
