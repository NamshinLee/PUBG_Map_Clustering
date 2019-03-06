function [point_class, point_x, point_y] = K_classify(seed_x,seed_y,x,y,phase)
point_x = x(phase == 1);
point_y = y(phase == 1);
distance = sqrt((repmat(point_x,size(seed_x))-repmat(seed_x,size(point_x))).^2+(repmat(point_y,size(seed_y))-repmat(seed_y,size(point_y))).^2);
[~,point_class] = min(distance,[],2);
end