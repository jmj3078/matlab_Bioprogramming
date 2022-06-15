%Question1)임의의 벡터 dice에서 주사위에서 5가 나오는 확률 계산
dice = [4 6 5 1 2 3 2 1 6]

num_five = length(find(dice == 5));
num_total = length(dice);
percentage_five = num_five / num_total;

percentage_five

%Question2-1)
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

%Question3-1)
body_stat = [1 173 75; 2 169 58; 1 180 78; 2 162 54]

log_male = body_stat(:, 1) == 1; %남성 논리값 추출
mean_male_height = mean(body_stat(log_male, 2)); 

mean_male_height

%Question3-2)
log_female = ~log_male; %여성의 논리값은 남성의 논리값의 부정
max_female_weight = max(body_stat(log_female, 3));

max_female_weight

%Question4-1)
v = [5 4 2 3 1 0 7] 
len_v = length(v);
diff_v(1:len_v-1) = v(2:len_v) - v(1:len_v-1);

diff_v

%Question4-2)
A = [1 3 4 2; 2 2 8 1; 3 3 2 4; 4 8 0 1]
len_col = length(A(1, :)); %열의 길이
len_row = length(A(:, 1)); %행의 길이
diff_A = A([1:len_row-1], [1:len_col]) - A([2:len_row], [1:len_col]);

diff_A