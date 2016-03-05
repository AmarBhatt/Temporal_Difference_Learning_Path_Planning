% Create Random Map
function map = map_create(m,n,s)

    %create mxn map
    map = rand(m,n);
    %normalize all values from 0-10
    map = map*10;
    %create integers
    map = floor(map);
    %create s states
    map = mod(map,s);
    %normalize from 1-5
    map = map + 1;  

    

    