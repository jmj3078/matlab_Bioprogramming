clear; 
clc; 

%% question 1

rand_integers = randi(20,1,10^8); 

tic; 
[odd_numbers1, even_numbers1] = split_odd_even1(rand_integers);
toc; 

tic; 
[odd_numbers2, even_numbers2] = split_odd_even2(rand_integers);
toc; 

all(odd_numbers1 == odd_numbers2) && all(even_numbers1 == even_numbers2)


%% question 2
data = [1 2 3 4 5; 11 9 14 39 18; 21 14 10 6 8];

s1 = std_dev(data) 
s2 = std(data) 
all(s1 == s2) 

%% question 3
load pset02;

weight_10th_max = xth_largest(weight_data, 10)

weight_200th_max = xth_largest(weight_data, 200)

weight_1003th_max = xth_largest(weight_data, 1003)

%% question 4
input_A = [
     1     2     3     4
     1     2     3     4
     1     2     3     4]
k = 2
rot_col(input_A, k)

input_A = [
     11    12    13    14
     21    22    23    24
     31    32    33    34];
k = 4
rot_col(input_A, k)

input_A = [
     1     4     7
     2     5     8
     3     6     9];

k = 7
rot_col(input_A, k)

%%  

%% function question 2

function S = std_dev(data_in)

sds = sum_diff_sqr(data_in); 

num_rows = size(data_in, 1); 

if num_rows > 1 
    S = sqrt( sds / (num_rows - 1) ); 
else
    S = sqrt( sds / (numel(data_in) - 1) ); 
end

end

function sds = sum_diff_sqr(data) 

M = mean(data);
sds = sum( (data - M).^2 ); 

end 

%% function question 3
function mx = xth_largest(data, x)

data_sort_desc = sort(data, 'descend');
mx = data_sort_desc(x);

end

%% function question 4
function rot_mtx = rot_col(mtx_in, k)

num_cols = size(mtx_in, 2);   
col_shift = rem(k, num_cols);
rot_mtx = [ mtx_in(:, num_cols-col_shift+1 : end) mtx_in(:, 1 : num_cols-col_shift) ]; 

end

%% function question 1
function [row_odd, row_even] = split_odd_even1(row_in)

row_odd=row_in(rem(row_in, 2) == 1);
row_even=row_in(rem(row_in, 2) == 0);

end

function [row_odd, row_even] = split_odd_even2(row_in)

is_odd = rem(row_in, 2) == 1;

row_odd=row_in(is_odd);
row_even=row_in(~is_odd);

end

