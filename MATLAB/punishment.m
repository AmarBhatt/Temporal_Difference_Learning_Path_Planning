% Using terrain weights and current state, find punishment of 
% current state
%
% t = current state (#)
% terrain = map
% weights = sensor data
% w = punishment factor
function p = punishment( t, terrain, weights, w )

[idr,idc] = getIndices(size(terrain,1),size(terrain,2),t);

type_idx = terrain(idr,idc);
p = sum(weights(type_idx,:)*w);

end

