% Based on a number find the r,c of it on an mxn matrix
function [r,c] = getIndices(m,n,i)
    r = ceil(i/n);
    c = i - (r-1)*n;
    
    