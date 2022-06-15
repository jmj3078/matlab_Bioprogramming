clc; clear

input_v = randi(100, 1000);
my_movmean(input_v,3)
movmean(input_v,3)

function mean_mov = my_movmean(input, n)
    if ~isvector(input) || mod(n,2) ~= 1
        error("input must be vector and odd value")
    end

    
end
