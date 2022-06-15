%% Question 1
test_A = randi(99,1,10);
test_B = randi(99,1,10);
test_C = randi(99,1,10);

%결과
[even_A, odd_A] = even_odd(test_A)
[even_B, odd_B] = even_odd(test_B)
[even_C, odd_C] = even_odd(test_C)

%% Question 2
sample = randi(99,5,4);

%std함수와의 결과 비교
std(sample)
std_matrix(sample)

%% Question 3 

%weight_data 불러오기
load("pset02.mat", "weight_data");
tic;
ranking(weight_data, 10)
ranking(weight_data, 200)
ranking(weight_data, 1003)
toc;

tic;
%unique를 활용한 함수와 출력값 비교
ranking_uniq(weight_data, 10)
ranking_uniq(weight_data, 200)
ranking_uniq(weight_data, 1003)
toc;
%% Question 4

input_A = [1 2 3 4 ; 1 2 3 4 ; 1 2 3 4]
input_B = [11 12 13 14 ; 21 22 23 24 ; 31 32 33 34]
input_C = [1 4 7; 2 5 8; 3 6 9]

shift_R(input_A, 2)
shift_R(input_B, 4)
shift_R(input_C, 7)

%% Question 1 function
function [even, odd] = even_odd(rand_int)
    %짝수, 홀수 논리값 벡터 생성
    log_even = [mod(rand_int, 2) == 0];
    log_odd = ~log_even;

    %짝수, 홀수 벡터 형성
    even = rand_int(log_even);
    odd = rand_int(log_odd);

end

%% Question 2 function
function standard_deviation = std_matrix(matrix)
    %열 길이 n 값 설정
    n = size(matrix,1);

    %표준편차 계산
    mean_val = mean(matrix);
    sum_squares = sum((matrix - mean_val).^2);
    variance = sum_squares / (n-1);
    standard_deviation = sqrt(variance);

end

%% Question 3 function - (1)
%{
  내림차순으로 정렬한 후 단순히 index 값을 순위로 나타내면, 중복된 값이 있을 경우
  순위가 제대로 출력되지 않는 문제가 있습니다. 따라서 내림차순으로 주어진 백터를 정렬하고
  중복을 제거하는 과정을 거치면, index 값이 곧 순위가 됩니다.
  내림차순으로 정렬된 후, 중복된 값들은 서로 뭉쳐있는 상태이기 때문에 단순히 자기 자신과
  그 다음 값들을 비교하여, 같을 경우에는 제외하고, 다른 경우에만 추가하는 방식으로 구현해보았습니다.
%}

%rank는 이미 존재하는 함수 이름이므로 다른 이름을 사용했습니다.
function rank = ranking(data, n)
    %내림차순 정렬
    sorted_data = sort(data, "descend");

    %내림차순으로 정렬된 상태에서, 중복된 값 제거
    rank_data = [];
    rank_data(1) = sorted_data(1);
    j = 2;

    for i = 2:size(sorted_data, 2)
        if sorted_data(i) ~= rank_data(j-1)
            rank_data(j) = sorted_data(i);
            j = j + 1;
        end
    end
    %내림차순으로 정렬되고, 중복이 제거된 상태 : index 값이 곧 순위가 됨
    rank = rank_data(n);

end

%% Question 3 function - (2)
%matlab 내장함수 unique를 사용하면 한번에 시행할 수 있습니다. 

function rank = ranking_uniq(data,n)
    sorted_unique_data = sort(unique(data), "descend");
    rank = sorted_unique_data(n);

end

%% Question 4 function
function shifted_m = shift_R(matrix, n)
    %주어진 matrix의 열 숫자
    col_num = width(matrix);

    %각 행 index값에 주어진 수만큼 더하고, 열의 수로 나눈 뒤 1을 더할 경우
    %오른쪽으로 회전하며 shift되는 형태를 구현할 수 있습니다.
    shifted_col_index = mod([1:col_num] + n, col_num) + 1;
    shifted_m = matrix(:, shifted_col_index);
    
end
