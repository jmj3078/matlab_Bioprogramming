%% question 1
dice = [4 6 5 1 2 3 2 1 6];

%{
num_all_toss = size(dice, 2); 
num_all_toss = length(dice); 
num_all_toss = numel(dice); 
%}

dice_size = size(dice); 
num_all_toss = dice_size(2);
num_5 = sum(dice == 5); 
prob_5 = num_5 / num_all_toss


%% question 2-1
A = [3     4     2;
     2     8     6;
     3     2     4;
     8     0     1];
 
num_row = size(A, 1); 
A = [A (1:num_row)']


%% question 2-1
A = [A(:, end) A(:, 1:end-1)] 


%% question 3
male = 1; 
female = 2; 
col_gender = 1; 
col_height = 2; 
col_weight = 3; 

body_stat = [1 173 75; 2 169 58; 1 180 78; 2 162 54];

male_height = body_stat( body_stat(:, col_gender) == male , col_height ); 
female_weight = body_stat( body_stat(:, col_gender) == female , col_weight ); 

%question 3-1) 
mean(male_height) 
%question 3-2) 
max(female_weight) 


%% question 4-1
v = [5 4 2 3 1 0 7];
diff_v = v(2:end) - v(1:end-1)

%% question 4-2
A = [
     1     3     4     2;
     2     2     8     6;
     3     3     2     4;
     4     8     0     1];
diff_A = A(2:end, :) - A(1:end-1, :)

