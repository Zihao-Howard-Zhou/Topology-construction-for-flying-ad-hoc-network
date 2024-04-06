function [fitness, longest_link_distance, minimum_node_distance] = Fitness(pos_uavs)

load parameter.mat source_set target d_max d_min lambda 

[number_of_uavs,~] = size(pos_uavs);

total_path_distance = zeros(length(source_set), 1);
maximum_link_distance = zeros(length(source_set), 1);

part1 = 0;
part2 = 0;

for source = 1:length(source_set)
    positions = [source_set(source, :); pos_uavs; target];
    [number_of_nodes, ~] = size(positions);
    
    edges = GraphConstruction(positions);
    cost = CalculateGraphCost(edges, positions, number_of_uavs);
    
    shortest_path = FindShortestPath(positions, cost, 1, number_of_nodes);

    for i = 1:length(shortest_path)-1
        link_distance = pdist2(positions(shortest_path(i+1),:), positions(shortest_path(i), :), 'squaredeuclidean');
        part1 = part1 + link_distance;
        
        if sqrt(link_distance) >= part2
            part2 = sqrt(link_distance);
        end
    end
    total_path_distance(source) = part1;
    maximum_link_distance(source) = part2;
    
    part1 = 0;
    part2 = 0; 
end

all_positions = [source_set; pos_uavs; target];
minimum_node_distance = min(pdist(all_positions));

fitness = sum(total_path_distance) + sum(lambda.* ((max(maximum_link_distance - d_max, 0)).^2))...
    + lambda * (max(d_min - minimum_node_distance).^2);
longest_link_distance = max(maximum_link_distance);

end

