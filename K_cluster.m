function [seed_x, seed_y, seed_r, point_class, point_x, point_y, point_t] = K_cluster(num,team,phase,x,y)
% Cluster Seed Point
seed_x = zeros(num-1,16);
seed_y = zeros(num-1,16);
seed_r = zeros(num-1,16);
for i=1:num-1
    for j=1:16
        pt_temp_x = x(phase==1&team==16*(i-1)+j);
        pt_temp_y = y(phase==1&team==16*(i-1)+j);
        seed_x(i,j) = mean(pt_temp_x);
        seed_y(i,j) = mean(pt_temp_y);
        seed_r(i,j) = mean(sqrt((pt_temp_x-seed_x(i,j)).^2+(pt_temp_y-seed_y(i,j)).^2));
    end
end

seed_r(isnan(seed_r)) = [];
seed_x(isnan(seed_x)) = [];
seed_y(isnan(seed_y)) = [];
[seed_r,idx] = sort(seed_r);
seed_x = seed_x(idx);
seed_y = seed_y(idx);

% Remove reduplicated seeds
i = 1;
while(i<size(seed_r,2))
    del_idx = [false(1,i) (seed_r(i)^2>(seed_x(i+1:end)-seed_x(i)).^2+(seed_y(i+1:end)-seed_y(i)).^2)];
    seed_r(del_idx) = [];
    seed_x(del_idx) = [];
    seed_y(del_idx) = [];
    i = i+1;
end

% Item Point & Cluster Initial Value
point_x = x(phase==1);
point_y = y(phase==1);
point_t = team(phase==1);
distance = sqrt((repmat(point_x,[1 size(seed_r,2)])-repmat(seed_x,[size(point_x,2) 1])).^2+(repmat(point_y,[1 size(seed_r,2)])-repmat(seed_y,[size(point_x,2) 1])).^2);
[~,point_class] = min(distance,[],2);

% K-clustering
point_class_old = zeros(size(point_class));
del_num = 0;
while(nnz(point_class_old ~= point_class)~=0)
    point_class_old = point_class;
    i = 1;
    while del_num+i<=size(seed_r,2)
        if nnz(point_class==i)==0
            del_num = del_num+1;
            seed_x(i) = [];
            seed_y(i) = [];
            point_class(point_class>i) = point_class(point_class>i)-1;
        else
            seed_x(i) = mean(point_x(point_class==i));
            seed_y(i) = mean(point_y(point_class==i));
        end
        i = i+1;
    end
    distance = sqrt((repmat(point_x,[1 size(seed_x,2)])-repmat(seed_x,[size(point_x,2) 1])).^2+(repmat(point_y,[1 size(seed_x,2)])-repmat(seed_y,[size(point_x,2) 1])).^2);
    [~,point_class] = min(distance,[],2);
end

% Cluster Radius
seed_r = zeros(size(seed_x));
for i=1:size(seed_r,2)
    seed_r(i) = mean(sqrt((point_x(point_class==i)-seed_x(i)).^2+(point_y(point_class==i)-seed_y(i)).^2));
end