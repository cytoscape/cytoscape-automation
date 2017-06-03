# Basic settings for cyREST
port.number = 1234
base.url = paste("http://localhost:", toString(port.number), "/v1", sep="")

# Utility to convert commands to query urls. Simply copy/paste command into string variables.
## example:
##  command = 'string disease query disease="glioblastoma multiforme" cutoff=0.9 species="Homo sapiens" limit=150'
command2query<-function(command){
    command = sub(" ([a-z]*=)","XXXXXX\\1",command)
    cmdargs = unlist(strsplit(command,"XXXXXX"))
    cmd = cmdargs[1]
    q.cmd = URLencode(paste(base.url, "commands", sub(" ","/",cmd), sep="/"))
    args = cmdargs[2]
    if (is.na(args)){
        q.cmd
    }else{
        args = gsub("\"","",args)
        args1 = unlist(str_extract_all(args,"[a-z]+(?==)"))
        args2 = unlist(strsplit(args," *[a-z]+="))
        args2 = args2[-1]
        q.args = NULL
        
        for (i in seq(args1)){
            arg = paste(args1[i],URLencode(args2[i]),sep="=")
            q.args = paste(q.args,arg,sep="&")
        }
        paste(q.cmd,q.args,sep="?")   
    }
}

#
# Returns edge attributes for member edges.
#
getCommunityEdge <- function(g, community) {
  num.edges <- ecount(g)
  edge.community <- array(0, dim=c(num.edges))
  edges <- get.edges(g, 1:num.edges)
  comms <- array(community)
  sources <- array(edges[,1])
  targets <- array(edges[,2])
  for(i in 1:num.edges) {
    if(i %% 1000 == 0) {
      print(i)
    }
    sidx <- sources[i]
    tidx <- targets[i]
    source <- comms[sidx]
    target <- comms[tidx]
    
    if(source == target) {
      edge.community[[i]] <- source
    }
  }
  return(edge.community)
}

toCytoscape <- function (igraphobj) {
  # Extract graph attributes
  graph_attr = graph.attributes(igraphobj)
  
  # Extract nodes
  node_count = length(V(igraphobj))
  if('name' %in% list.vertex.attributes(igraphobj)) {
    V(igraphobj)$id <- V(igraphobj)$name
  } else {
    V(igraphobj)$id <- as.character(c(1:node_count))
  }

  nodes <- V(igraphobj)
  v_attr = vertex.attributes(igraphobj)
  v_names = list.vertex.attributes(igraphobj)
  
  nds <- array(0, dim=c(node_count))
  for(i in 1:node_count) {
    if(i %% 1000 == 0) {
      print(i)
    }
    nds[[i]] = list(data = mapAttributes(v_names, v_attr, i))
  }
  
  edges <- get.edgelist(igraphobj)
  edge_count = ecount(igraphobj)
  e_attr <- edge.attributes(igraphobj)
  e_names = list.edge.attributes(igraphobj)
  
  attr_exists = FALSE
  e_names_len = 0
  if(identical(e_names, character(0)) == FALSE) {
    attr_exists = TRUE
    e_names_len = length(e_names)
  }
  e_names_len <- length(e_names)
  
  eds <- array(0, dim=c(edge_count))
  for(i in 1:edge_count) {
    st = list(source=toString(edges[i,1]), target=toString(edges[i,2]))
    
    # Extract attributes
    if(attr_exists) {
      eds[[i]] = list(data=c(st, mapAttributes(e_names, e_attr, i)))
    } else {
      eds[[i]] = list(data=st)
    }
    
    if(i %% 1000 == 0) {
      print(i)
    }
  }

  el = list(nodes=nds, edges=eds)
  
  x <- list(data = graph_attr, elements = el)
  print("Done.  To json Start...")
  return (toJSON(x))
}

mapAttributes <- function(attr.names, all.attr, i) {
  attr = list()
  cur.attr.names = attr.names
  attr.names.length = length(attr.names)
  
  for(j in 1:attr.names.length) {
    if(is.na(all.attr[[j]][i]) == FALSE) {
#       attr[j] = all.attr[[j]][i]
      attr <- c(attr, all.attr[[j]][i])
    } else {
      cur.attr.names <- cur.attr.names[cur.attr.names != attr.names[j]]
    }
  }
  names(attr) = cur.attr.names
  return (attr)
}


send2cy <- function(cygraph, style.name, layout.name) {
  network.url = paste(base.url, "networks", sep="/")
  res <- POST(url=network.url, body=cygraph, encode="json")
  network.suid = unname(fromJSON(rawToChar(res$content)))
  print(network.suid)
  
  # Apply Visual Style
  apply.layout.url = paste(base.url, "apply/layouts", layout.name, toString(network.suid), sep="/")
  apply.style.url = paste(base.url, "apply/styles", style.name, toString(network.suid), sep="/")
  
  res <- GET(apply.layout.url)
  res <- GET(apply.style.url)
}

# Generate color palet using number of communitie
communityToColors <- function(members, num.communities) {
  base.color <- "#AAAAAA"
  num.members <- length(members)
  colors <- array(base.color, dim=c(num.members))

  # Split color space into number of communities
  color.pallet <- rainbow(num.communities)

  for(i in 1:num.members) {
    newcolor <- color.pallet[members[i]]
    if(length(newcolor) == 0) {
      newcolor <- base.color
    }
    colors[i] <- newcolor
  }
  result <- array(sapply(colors,function(x){return(substring(x, 1, 7))}))
  return(result)
}

buildStyle <- function(style.name, g, colors, community) {
  # Preepare Defaults
  def.node.border.width <- list(
    visualProperty = "NODE_BORDER_WIDTH",
    value = 0
  )

  def.node.transparency <- list(
    visualProperty="NODE_TRANSPARENCY",
    value=230
  )

  def.edge.transparency <- list(
    visualProperty="EDGE_TRANSPARENCY",
    value=120
  )

  def.edge.width <- list(
    visualProperty="EDGE_WIDTH",
    value=2
  )

  def.network.background <- list(
    visualProperty = "NETWORK_BACKGROUND_PAINT",
    value = "black"
  )

  defaults <- list(
    def.node.border.width,
    def.edge.width,
    def.node.transparency,
    def.edge.transparency,
    def.network.background
  )

  # Mappings
  mappings = list()

  # Color mappings
  node.fill.color = list(
    mappingType="passthrough",
    mappingColumn=colors,
    mappingColumnType="String",
    visualProperty="NODE_FILL_COLOR"
  )

  edge.color = list(
    mappingType="passthrough",
    mappingColumn=colors,
    mappingColumnType="String",
    visualProperty="EDGE_STROKE_UNSELECTED_PAINT"
  )

  # Node Size Mapping
  min.betweenness = min(V(g)$betweenness)
  max.betweenness = max(V(g)$betweenness)

  point1 = list(
    value=min.betweenness,
    lesser= "5.0",
    equal="5.0",
    greater="5.0"
  )

  point2 = list(
    value=max.betweenness,
    lesser="100.0",
    equal="100.0",
    greater="100.0"
  )

  node.size.continuous.points = list(point1, point2)

  node.size = list(
    mappingType="continuous",
    mappingColumn="betweenness",
    mappingColumnType="Double",
    visualProperty="NODE_SIZE",
    points = node.size.continuous.points
  )

  edge.trans.point = list(
    value=1.0,
    lesser= "40",
    equal="200",
    greater="200"
  )

  edge.trans.continuous.points = list(edge.trans.point)

  edge.trans = list(
    mappingType="continuous",
    mappingColumn=community,
    mappingColumnType="Double",
    visualProperty="EDGE_TRANSPARENCY",
    points = edge.trans.continuous.points
  )

  mappings = list(node.fill.color, edge.color, node.size, edge.trans)

  style <- list(title=style.name, defaults = defaults, mappings = mappings)
  return(toJSON(style))
}




buildStyleSimple <- function(style.name, g, colors) {
  # Preepare Defaults
  def.node.border.width <- list(
    visualProperty = "NODE_BORDER_WIDTH",
    value = 0
  )

  def.edge.width <- list(
    visualProperty="EDGE_WIDTH",
    value=2
  )

  def.network.background <- list(
    visualProperty = "NETWORK_BACKGROUND_PAINT",
    value = "white"
  )

  defaults <- list(
    def.node.border.width,
    def.network.background
  )

  # Mappings
  mappings = list()

  # Color mappings
  node.fill.color = list(
    mappingType="passthrough",
    mappingColumn=colors,
    mappingColumnType="String",
    visualProperty="NODE_FILL_COLOR"
  )

  edge.color = list(
    mappingType="passthrough",
    mappingColumn=colors,
    mappingColumnType="String",
    visualProperty="EDGE_STROKE_UNSELECTED_PAINT"
  )

  #name mapping
  node.label = list(
    mappingType="passthrough",
    mappingColumn="name",
    mappingColumnType="String",
    visualProperty="NODE_LABEL"
  )

  mappings = list(node.fill.color, edge.color,node.label)

  style <- list(title=style.name, defaults = defaults, mappings = mappings)
  return(toJSON(style))
}


processNodeAttributes<-function(g,g.NEL){

  g.vertexNames<-vertex_attr_names(g)

  for (index in 1:length(g.vertexNames)){
    name<-g.vertexNames[index]

    if (class(igraph::vertex_attr(g,name = name,1))=="character") {
      type="char"
      default=""
    }
    else if (class(igraph::vertex_attr(g,name = name,1))=="numeric") {
      type="numeric"
      default=1
    }
    print(type)
    print(name)
    print(default)
    g.NEL<-initNodeAttribute(graph = g.NEL,attribute.name = name,attribute.type = type,default.value = default)
    if(type =="char"){
      nodeData(self = g.NEL,n = V(g)$name,attr = name)<-vertex_attr(g,name,1:vcount(g))
    }
    else{
      nodeData(self = g.NEL,n = V(g)$name,attr = name)<-as.numeric(vertex_attr(g,name,1:vcount(g)))
    }

  }
  nodeDataDefaults(g.NEL,"label")<-"default"
  nodeData(self = g.NEL,V(g)$name,"label")<-V(g)$name
  g.NEL<-initNodeAttribute(g.NEL,attribute.name = "label",attribute.type = "char",default.value = "name")

  return(g.NEL)
}

processEdgeAttributes<-function(g,g.NEL){

  g.edgeNames<- edge_attr_names(g)

  for (index in 1:length(g.edgeNames)){
    name<-g.edgeNames[index]

    if (class(igraph::edge_attr(g,name = name,1))=="character") {
      type="char"
      default=""
    }
    else if (class(igraph::edge_attr(g,name = name,1))=="numeric") {
      type="numeric"
      default=1
    }
    g.NEL<-initEdgeAttribute(g.NEL,name,type,default)

  }
  g.NEL<-initEdgeAttribute(g.NEL,"weight","numeric",1)

  return(g.NEL)
}

