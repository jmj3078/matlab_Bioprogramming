clear; clc
%% Question 1
input = randi(40,1,20)

%for문을 사용한 경우와 sort를 사용한 경우를 내장함수 min과 비교해 보았습니다.
%내장함수 sort를 사용하는 것이 for문을 활용하는 것 보다 더 빨랐습니다.
tic;
[w1, i1] = my_min_func_for(input); %for문 사용
toc;

tic;
[w2, i2] = my_min_func_sort(input); %내장함수 sort사용
toc;

tic;
[w3, i3] = min(input); %min함수와 비교
toc;

disp([w1, i1]);
disp([w2, i2]);
disp([w3, i3]);

%% Question 2
line_vector = 1:5;

%2-1
for ii = 1:5
    disp(line_vector(1:ii));
end

%2-2
for ii = 5:-1:1
    disp(line_vector(5:-1:ii));
end

%2-3
for ii = 1:5
    disp(line_vector(ii:5));
end

%2-4
num1 = 1; 
for ii = 1 : 5
    num2 = num1 + (ii-1);
    line_vector = num1 : num2;
    disp(line_vector);
    num1 = num2 + 1;
end

%% Question 3-1
A = [1 2 3; 4 5 6; 7 8 9]
B = [1 2; 3 4; 5 6]
disp(A*B);
disp(matrix_multiply_1(A,B));

%% Question 3-2

disp(matrix_multiply_2(A,B));

%% Question 1 function

%for문 사용한 경우
function [min, index] =  my_min_func_for(vec)
TF = isvector(vec);
    if TF == 0
        error("Input must be vector\n")
    else
        %for문을 사용한 최솟값과 그 인덱스 구하기
        min = vec(1);
        for ii = (2:numel(vec))
            if min > vec(ii)
                min = vec(ii);
                index = ii;
            end
        end
    end
end

%for 문 대신 내장함수 sort를 사용한 경우
function [min, index] =  my_min_func_sort(vec)
TF = isvector(vec);
    if TF == 0
        error("Input must be vector\n")
    
    else
        %오름차순으로 정렬하여 최솟값 구하기
        sorted_vec = sort(vec);
        min = sorted_vec(1);

        %find함수 없이 index값 구하기 (find사용시 연산 속도 대폭 증가)
        key = 1:numel(vec);
        index_vec = key(vec == min);
        index = index_vec(1);
    end
end

%% Question 3-1 function

%행렬 A X B에서 A의 제 i행과 B의 제 j열의 성분을 차례대로 곱하여 더한 값이 (i,j)성분이 됩니다.
%곱한 행렬의 크기는 (A의 행 개수,  B의 열 개수)가 됩니다.

function M = matrix_multiply_1(A, B)
    coln_A = size(A, 2); %A 열 개수
    rown_A = size(A, 1); %A 행 개수
    coln_B = size(B, 2); %B 열 개수
    rown_B = size(B, 1); %B 행 개수
    
    %A의 열 개수 = B의 행 개수일 경우에만 계산 가능, 에러출력
    if coln_A ~= rown_B
        error("The number of columns of A must be equal to the number of rows of B\n")
    end
    
    M = zeros(rown_A, coln_B);

    for ii = 1:rown_A 
        for jj = 1:coln_B 
            for kk = 1:coln_A
                M(ii, jj) =  M(ii, jj) + (A(ii, kk) * B(kk, jj));
            end
        end
    end

end
%% Question 3-2 function

function M = matrix_multiply_2(A, B)
    coln_A = size(A, 2); %A 열 개수
    rown_A = size(A, 1); %A 행 개수
    coln_B = size(B, 2); %B 열 개수
    rown_B = size(B, 1); %B 행 개수

    if coln_A ~= rown_B
        error("The number of columns of A must be equal to the number of rows of B\n")
    end

    M = zeros(rown_A, coln_B);
    
    %A을 전치시킨 뒤 접근하면, A는 행 순으로 B는 열 순으로 접근할 수 있게 된다.
    index = 1;
    for ii = A'
        for jj = B
            %sum(ii.*jj)과 같다
            M(index) = ii'*jj; 
            index = index + 1;
        end
    end
end
