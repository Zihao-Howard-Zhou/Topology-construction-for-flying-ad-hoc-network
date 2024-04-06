function shortestPath = FindShortestPath(...
    positions, ...
    cost, ...
    source_node_id, ...
    target_node_id)
% Function: FindShortestPath
% Description: use Dijstra's algorithm to find the shortest path
% Input: positions:
%        cost
%        source_node_id
%        target_node_id
% Output: shortestPath: sequence (id) of relay nodes
% Author: Zihao Zhou, eezihaozhou@gmail.com
% Updated at: 2024/4/6

numNodes = size(positions, 1);

distance = inf(1, numNodes);  
prevNode = zeros(1, numNodes); 
visited = false(1, numNodes);  

distance(source_node_id) = 0; 

for i = 1:numNodes
    u = FindMinDistanceNode(distance, visited);  
    
    visited(u) = true;
    
    for v = 1:numNodes
        if ~visited(v) && cost(u, v) > 0 && cost(u, v) ~= inf
            alt = distance(u) + cost(u, v);
            if alt < distance(v)
                distance(v) = alt;
                prevNode(v) = u;
            end
        end
    end  
end

path = [];
currentNode = target_node_id;
while currentNode ~= 0
    path = [currentNode path];
    currentNode = prevNode(currentNode);
end

if length(path)==1 
    shortestPath = [];
else
    shortestPath = path;
end

end

function minNode = FindMinDistanceNode(dist, visited)
    minDist = inf;
    minNode = 1;
    for i = 1:length(dist)
        if ~visited(i) && dist(i) < minDist
            minDist = dist(i);
            minNode = i;
        end
    end
end


