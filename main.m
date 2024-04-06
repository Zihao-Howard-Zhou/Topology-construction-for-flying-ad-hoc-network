clc
clear
close all

r_uav_list = 1:1:15;
seed_list = 1;

objective_function = zeros(length(seed_list), length(r_uav_list));  % fitness
longest_link_distance = zeros(length(seed_list), length(r_uav_list));
shortest_node_distance = zeros(length(seed_list), length(r_uav_list));

for s = 1:length(seed_list)
    seed = seed_list(s);
    rng(seed);
    for j = 1:length(r_uav_list)
        m = r_uav_list(j);
        disp(['At seed: ', num2str(seed), ' uav num is: ', num2str(m)]);  

        [pos, fit, max_link_d, min_node_d] = PsoOptimization(m, seed);
        
        objective_function(s, j) = fit(end);
        longest_link_distance(s, j) = max_link_d(end);
        shortest_node_distance(s, j) = min_node_d(end);
    end
end

mean_obj = mean(objective_function, 1);
mean_max_link_d = mean(longest_link_distance, 1);
mean_min_node_d = mean(shortest_node_distance, 1);

plot(r_uav_list, mean_obj);