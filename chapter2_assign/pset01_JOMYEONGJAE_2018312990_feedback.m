%% Question1)임의의 벡터 dice에서 주사위에서 5가 나오는 확률 계산
dice = [4 6 5 1 2 3 2 1 6]

num_five = length(find(dice == 5));
num_total = length(dice);
percentage_five = num_five / num_total;

percentage_five

% prof comment: find 없이 일치하는 것들의 갯수를 세는 방법을 사용하는 것이 더 좋음 (sum)
% prof comment: 20점 

%% Question2-1)
matrix = [3 4 2; 2 8 6; 3 2 4; 8 0 1]

num_row = length(matrix(:, 1)); %주어진 행렬 열의 길이 = 행의 개수
num_row_vec = (1:num_row); %행의 숫자를 나타내는 벡터
matrix = [matrix, num_row_vec']; %벡터를 transpose하여 열방향으로 추가

matrix

%Question2-2) 
%circshift함수 사용 : matrix = circshift(matrix, 1, 2)

num_col = length(matrix(1, :)); %주어진 행렬 행의 길이 = 열의 개수
matrix(:, [2:num_col]) = matrix(:, [1:num_col-1]); %한칸씩 오른쪽으로 밀어내기
matrix(:, 1) = num_row_vec'; %첫번째 열에 행 숫자를 나타내는 벡터를 transpose하여 대치

matrix

% prof comment: num_row_vec을 다시 사용하는 것보다는 2-1에서 계산 완료된 matrix의 마지막 열을 사용하라는 의도의 문제
% prof comment: 15 + 15 점

%% Question3-1)
body_stat = [1 173 75; 2 169 58; 1 180 78; 2 162 54]

log_male = body_stat(:, 1) == 1; %남성 논리값 추출
mean_male_height = mean(body_stat(log_male, 2)); 

mean_male_height

%Question3-2)
log_female = ~log_male; %여성의 논리값은 남성의 논리값의 부정 % prof_comment : good
max_female_weight = max(body_stat(log_female, 3));

max_female_weight

% prof comment: 10 + 10 점

%% Question4-1)
v = [5 4 2 3 1 0 7] 
len_v = length(v);
diff_v(1:len_v-1) = v(2:len_v) - v(1:len_v-1);

diff_v

%Question4-2)
A = [1 3 4 2; 2 2 8 6; 3 3 2 4; 4 8 0 1]
len_col = length(A(1, :)); %열의 길이
len_row = length(A(:, 1)); %행의 길이
diff_A = A([1:len_row-1], [1:len_col]) - A([2:len_row], [1:len_col]); % prof comment: 모든 열이면 1:len_col 대신 : 사용 가능. 

diff_A

% prof comment: diff_v구할 때 index를 지정해서 계산한 것처럼 diff_A도 마찬가지 방법 사용 가능. 
% prof comment: 15 + 15 = 30점

%%
% prof comment: 총점 20 + 15 + 15 + 10 + 10 + 15 + 15 = 100점

