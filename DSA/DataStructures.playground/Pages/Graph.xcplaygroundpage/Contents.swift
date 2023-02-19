protocol Graph {
    associatedtype Element
    typealias Edge = GraphEdge<Element>
    typealias Vertex = Edge.Vertex
    
    var vertices: [Vertex] { get }
    
    mutating func addVertex(_: Element) -> Vertex
    mutating func addEdge(_: Edge, isDirectional: Bool)
    func getEdges(from: Vertex) -> [Edge]

}

struct GraphVertex<Element> {
    let index: Int
    let element: Element
}

// Vertex needs to be hashable to have the index in the graph
extension GraphVertex: Hashable where Element: Hashable { }

extension GraphVertex: Equatable where Element: Equatable { }

struct GraphEdge<Element> {
    typealias Vertex = GraphVertex<Element>
    let weight: Int
    let source: Vertex
    let destination: Vertex
}

extension GraphEdge: Hashable where Element: Hashable { }

extension GraphEdge: Equatable where Element: Equatable { }

struct AdjacencyList<Element>: Graph where Element:Hashable {
    
    typealias Edge = GraphEdge<Element>
    typealias Vertex = Edge.Vertex
    var adjacencies: [Vertex: [Edge]] = [:]
    
    // Protocol Graph Conformance
    var vertices: [Vertex] {
        return Array(adjacencies.keys)
    }
    
    mutating func addVertex(_ element: Element) -> Vertex {
        let vertex = Vertex(index: adjacencies.count, element: element)
        adjacencies[vertex] = []
        return vertex
    }
    
    mutating func addEdge(_ edge: Edge, isDirectional: Bool = false) {
        adjacencies[edge.source]?.append(edge)
        
        // if its undirected/bidirectional graph, then we need to add the reverse edge to the adjacency list as well
        if !isDirectional {
            let reverseEdge = Edge(weight: edge.weight, source: edge.destination, destination: edge.source)
            adjacencies[edge.destination]?.append(reverseEdge)
        }
    }
    
    func getEdges(from vertex: Vertex) -> [Edge] {
        adjacencies[vertex] ?? []
    }

}

extension Graph where Element: Hashable {
    func getPaths(from source: Vertex, to destination: Vertex) -> Set<[Edge]> {
        var completedPaths = Set<[Edge]>()
        
        
        return completedPaths
    }
}
