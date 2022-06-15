
%% question 1

clear; clc;

% 다음 시간에 배울 "cell" 예습 삼아.
v{1} = randi(15, 1, 10); 
v{2} = randi(15, 10, 1); 

for ii = 1 : numel(v) 
    [m1,I1] = min_vector(v{ii}); 
    [m2,I2] = min(v{ii});
    
    disp('input: ');
    disp(v{ii});
    disp({'min1: ' m1 'index1: ' I1});
    disp({'min2: ' m2 'index2: ' I2});
    
    if isequal([m1 I1], [m2 I2])
        disp('works well');
    end
end

%% question 2

clear; clc;
format compact

disp('(1)');
for ii = 1 : 5
    line_vector = 1 : ii;
	disp(line_vector);
end
disp(' ');

disp('(2)');
for ii = 5 : -1 : 1
    line_vector = 5 : -1 : ii;
    disp(line_vector);
end
disp(' ');

disp('(3)');
for ii = 1 : 5
    line_vector = ii : 5;
    disp(line_vector);
end
disp(' ');

disp('(4)');
n1 = 1; 
for ii = 1 : 5
    n2 = n1 + ii - 1; 
    line_vector = n1 : n2; 
    disp(line_vector);
    n1 = n2 + 1; 
end
disp(' ');

format loose 

%% question 3

clear; clc;
A = randi(9, 4, 2);
B = randi(9, 3, 4);

M1 = matrix_multiply_1(A, B);
M2 = matrix_multiply_2(A, B);
M0 = A*B;

if isequal(M0, M1)
    disp(A);
    disp('*');
    disp(B);
    disp(M1);    
    disp('matrix_multiply_1 function correct');
end
if isequal(M0, M2)
    disp(A);
    disp('*');
    disp(B);
    disp(M2);    
    disp('matrix_multiply_2 function correct');
end


%% question 1 function
function [m, I] = min_vector(v)

m = [];
I = [];

if sum(size(v) == 1) ~= 1
    disp('input must be a vector'); 
    return; 
end

N = numel(v);
m = v(1); I = 1;

for ii = 2 : N
    if m > v(ii)
        m = v(ii); 
        I = ii;
    end
end

end

%% question 3 functions
function M = matrix_multiply_1(A, B)

[M, m, l, n] = prepare_multiply_matrix(A, B); 

for ii = 1 : m
    for jj = 1 : l
        for kk = 1 : n
             M(ii, jj) =  M(ii, jj) + A(ii, kk) * B(kk, jj);
        end
    end
end

end

function M = matrix_multiply_2(A, B)

M = prepare_multiply_matrix(A, B); 

idx = 0;
for jj = B
    for ii = A'
        idx = idx + 1;
        M(idx) = ii' * jj;
    end
end

end

function [M, m, l, n] = prepare_multiply_matrix(A, B) 

[m,  n] = size(A);
[n1, l] = size(B);
M = zeros(m, l);

if n ~= n1
    error('number of columns of A must be equal to the number of rows of B');
end

end
