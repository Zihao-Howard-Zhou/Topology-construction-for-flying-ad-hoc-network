function [position_each_iter, ...
    fitness_each_iter, ...
    maximum_link_distance_each_iter, ...
    minimum_node_distance_each_iter] = PsoOptimization(...
    number_of_uavs, ...
    seed)
% Function: PsoOptimization
% Description: use PSO to find optimal positions of uavs to minimize the
%              total distance of all paths
% Input: 1) pos_users: position of ground users
%        2) number_of_uavs
%        3) routing_scheme: indicate which routing protocol is adopted
%        4) seed: random seed to ensure reproduction
% Output: 1) position_each_iter: best 2D position in each iteration
%         2) fitness_each_iter: fitness value in each iteration
%         3) maximum_link_distance_each_iter
%         4) minimum_node_distance]
% Author: Zihao Zhou, eezihaozhou@gmail.com
% Updated at: 2024/4/6

load parameter.mat area max_iteration num_particles w c1 c2

x_min = area(1,1);
x_max = area(1,2);
y_min = area(2,1);
y_max = area(2,2);

position_each_iter = zeros(number_of_uavs, 2, max_iteration); 
fitness_each_iter = zeros(max_iteration, 1);
maximum_link_distance_each_iter = zeros(max_iteration, 1);  
minimum_node_distance_each_iter = zeros(max_iteration, 1);

% paricle construction
x0.position = [];  % location of particles
x0.velocity = [];  % velocity of particles
x0.fitness = [];  % fitness 
x0.best.fitness =[];  % individual optimal fitness
x0.best.position =[];  % locations corresponding to individual optimal fitness
x = repmat(x0,num_particles,1);  % paricle construction

global_best.fitness = inf;  % global best fitness
global_maximum_link_distance = 0;
global_minimum_node_distance = 0;

% particles initialization
for i = 1:num_particles
    rng(seed+i+2024);
    init_pos_x = x_min + (x_max - x_min) * rand(number_of_uavs, 1);

    rng(seed+i+2025);
    init_pos_y = y_min + (y_max - y_min) * rand(number_of_uavs, 1);

    x(i).position = [init_pos_x init_pos_y];
    
    rng(seed+i+2026);
    x(i).velocity = rand(number_of_uavs, 2);
    
    % fitness calculation
    [x(i).fitness, longest_link_dist, minimum_node_dist] = Fitness(x(i).position);
    
    x(i).best.position = x(i).position; 
    x(i).best.fitness = x(i).fitness;
    
    if x(i).best.fitness < global_best.fitness
        global_best = x(i).best; 
        global_maximum_link_distance = longest_link_dist;
        global_minimum_node_distance = minimum_node_dist;
    end
end

% PSO iteration
for j = 1:max_iteration
    for p = 1:num_particles
        % update random component of velocities of particles
        rng(seed+j+p+2027);
        r1 = rand(number_of_uavs, 2);
        
        rng(seed+j+p+2028);
        r2 = rand(number_of_uavs, 2);
          
        % update velocities
        x(p).velocity = w * x(p).velocity + c1 * r1.*(x(p).best.position - x(p).position)...
                + c2 * r2.*(global_best.position - x(p).position);
        x(p).position = x(p).position + x(p).velocity;  % update locations
        
        % boundary check
        x(p).position(:, 1) = max(min(x(p).position(:, 1), x_max), x_min);
        x(p).position(:, 2) = max(min(x(p).position(:, 2), y_max), y_min);
        
        [x(p).fitness, longest_link_dist, minimum_node_dist] = Fitness(x(p).position);
        
        if x(p).fitness < x(p).best.fitness
            x(p).best.position = x(p).position;
            x(p).best.fitness = x(p).fitness;
            
            if x(p).best.fitness < global_best.fitness
                global_best = x(p).best;
                global_maximum_link_distance = longest_link_dist;
                global_minimum_node_distance = minimum_node_dist;
            end
        end   
    end
    position_each_iter(:,:,j) = global_best.position;
    fitness_each_iter(j) = global_best.fitness;
    maximum_link_distance_each_iter(j) = global_maximum_link_distance;
    minimum_node_distance_each_iter(j) = global_minimum_node_distance;

%     plot(fitness_each_iter(1:j, 1), 'r-', 'linewidth',1.2); %
%     drawnow
end

end

