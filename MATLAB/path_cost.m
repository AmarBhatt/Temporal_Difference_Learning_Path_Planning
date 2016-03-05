% Calculate cost of path by including terrain data
function [c,average] = path_cost(terrain,path,weights)
    c = 0;
    for i = 1:length(path)
        [row,col] = getIndices(size(terrain,1),size(terrain,2),path(i));
        c = c + sum(weights(terrain(row,col),:));
    end
    
    average = c/length(path);
    