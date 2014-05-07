function var = thresh(var,x)

if ~exist('x','var')
    x = 0;
end

if var < x
    var = x;
end

end