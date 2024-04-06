function [cost] = CalculateGraphCost(edges, positions, number_of_uavs)
% Function: CalculateGraphCost
% Description: calculate the costs of edges
% Input: 1) edges: the collections of edges in communication graph
%        2) number_of_uavs
% Output: cost: edge weight matrix
% Author: Zihao Zhou, eezihaozhou@gmail.com
% Updated at: 2024/3/30

cost = zeros([number_of_uavs+2, number_of_uavs+2]);  % initialization
cost(end, :) = inf;  % packets are not allowed to go out from the BS

[edges_num, ~] = size(edges);

for e = 1:edges_num
    edge = edges(e, :);
    
    if cost(edge(1), edge(2)) ~= inf         
        distance = pdist2(positions(edge(1), :), positions(edge(2), :), 'squaredeuclidean');

        edgecost = distance;  
        
        cost(edge(1), edge(2)) = edgecost ;
        if cost(edge(2), edge(1)) ~= inf
            cost(edge(2), edge(1)) = edgecost;
        end 
    end   
end

end

