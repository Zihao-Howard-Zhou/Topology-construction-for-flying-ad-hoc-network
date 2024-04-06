function edges = GraphConstruction(points)
% Function: GraphConstruction
% Description: build the connection relationship between nodes
% Input: points: coordinates of all nodes  
% Output: edges: M x 2 matrix, M represents the total number of edges
% Author: Zihao Zhou, eezihaozhou@gmail.com
% Updated at: 2024/4/6
    
edges = [];

[number_of_uavs, ~] = size(points);

for i = 1:number_of_uavs
    for j = 1:number_of_uavs
        if i~=j
            edge = [min(i, j), max(i, j)];
            edges = [edges; edge];
        end
    end  
end

% remove duplicates
edges = unique(edges, 'rows');
end

