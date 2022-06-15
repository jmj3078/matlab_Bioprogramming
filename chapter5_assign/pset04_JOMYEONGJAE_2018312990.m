clc; clear
%% Question 1 
disp("Question 1")
disp("==========================================================");

guess_my_number()

%% Question 2
disp("Question 2")
disp("==========================================================");

sample_1 = randi(10,1,10); %작은 벡터
sample_2 = randi(10,1,1000); %큰 벡터

%함수 결과값 테스트

disp("results of my_movmean and movmean")
disp("==========================================================");
disp(my_movmean(sample_1, 3));
disp(movmean(sample_1, 3));

disp("comparing results of my_movmean and movmean")
disp("==========================================================");
disp(my_movmean(sample_1, 3) == movmean(sample_1, 3));

disp(my_movmean(sample_2, 5) == movmean(sample_2, 5));
%모두 똑같음

%에러출력
%my_movmean(sample_1, -1)
%my_movmean([1 2 ; 3 4], 2) 



%% Question 3
%pset04.mat에 있는 변수 모두 꺼내오기
disp("Question 3")
disp("==========================================================");

load("pset04.mat")

nrow_species = size(sample_to_species,1);
size_grid = size(sample_in_grid);

%grid에 종 개수를 나타낸 새로운 행열 생성
species_in_grid = zeros(size_grid);

for ii = 1:nrow_species
    n_in_grid = sample_to_species(ii,1);
    n_species = sample_to_species(ii,2);
    
    idx_grid = find(sample_in_grid == n_in_grid);
    
    species_in_grid(idx_grid) = n_species;

end

disp(sample_to_species);
disp(sample_in_grid);
disp(species_in_grid);

%% Question 1 function : guess_my_number()

function guess_my_number()
while 1

    %주요 변수 초기화
    continue_game = 0; n_continue = 1; 
    guess_log = []; guess_min = 1; guess_max = 100;
    player_ans = 0; guess_num = [];

    %게임시작 / 플레이 여부 질문 
    start_switch = game_start();
    
    %게임의 반복적 실행, start_switch 값이 0일 경우 반복문 실행하지 않음
    while start_switch
    
        %값 추측, 변수 갱신
        %guess_number_1 을 사용해도, guess_number_2를 사용해도 모두 정상작동됨을 확인했습니다.
        [guess_log, guess_min, guess_max, guess_num] = guess_number_1(player_ans,guess_log,guess_min,guess_max);
        %[guess_log, guess_min, guess_max, guess_num] = guess_number_2(player_ans,guess_log,guess_min,guess_max);


        %플레이어 해답 입력
        player_ans = get_player_ans(guess_num);
    
        %플레이어 해답이 정답일 경우
        if player_ans == 3
            continue_game = ask_contiue_game();
            break;
            end
    end

    %컴퓨터가 답을 맞춰 게임이 종료된 후, continue_game값이 갱신되면 continue통해 루프 반복,
    %게임이 실행되지 않은 경우엔 continue_game이 기본값인 0을 가지고 있고
    %플레이어가 다시 플레이 하기를 원치 않을 경우에도 continue_game이 0이므로 루프 탈출.
    if continue_game == n_continue
        continue
    else
        break;
    end

end
end

%% 게임 시작 function : 게임 시작 변수 start_switch반환
function start_switch = game_start()
while 1
    disp_str = "1~100사이의 숫자를 하나 생각해주세요, 게임을 시작합니까? [yes:1 / no:2]: ";
    input_n = input(disp_str);
    input_yes = 1;
    input_no = 2;
    if input_n == input_yes
        start_switch = 1;
        disp("게임을 시작합니다!");
        disp("==========================================================");
        break;
    elseif input_n == input_no
        start_switch = 0;
        disp("게임을 종료합니다.");
        disp("==========================================================");
        break;
    else 
        disp("숫자 1 또는 2를 입력하세요!")
        continue;
    end
end

end

%% 플레이어 해답 입력받는 function : 플레이어 해답 값인 1, 2, 3을 반환
function player_ans = get_player_ans(guess_num)

%적절한 대답 : 크다 1, 작다 2, 같다 3 을 제외한 다른 숫자를 입력하는 경우를 필터링
n_bigger = 1; n_smaller = 2; n_correct = 3;
proper_ans = [n_bigger, n_smaller, n_correct];

while 1 
    player_ans = input(['[' num2str(guess_num) ']이/가 생각한 숫자와 같나요? (1:더 커요/2:더 작아요/3:정확해요): ']);
    if ismember(player_ans, proper_ans)
        break;
    
    else
        disp("숫자 1, 2, 3 중 하나를 입력해주세요!");
        continue; %재 입력을 위한 continue 활용

    end
end
end
%% 숫자 추측 function(1)
%{
    제시하는 숫자보다 크다면 그 숫자를 최솟값으로 지정하고,
    제시하는 숫자보다 작다면 그 숫자를 최댓값으로 지정한 뒤 그 사이의 랜덤한 숫자를 골라 제시합니다.
    randi 함수를 사용하여 구현했습니다.
    처음 게임을 시작할 때는 player_ans값이 0이기 때문에, 따로 분기를 설정하였습니다.  
    한꺼번에 추측에 필요한 변수들을 넣어서, 다시 갱신해야 하는 변수들을 반환하는 형태로 만들어 보았습니다.
%}
function [guess_log, guess_min, guess_max, guess_num] = guess_number_1(player_ans, guess_log, guess_min, guess_max)

n_empty = 0; n_bigger = 1; n_smaller = 2; 

if player_ans == n_empty
    guess_num = randi([guess_min, guess_max]);
    guess_log(end+1) = guess_num;

elseif player_ans == n_bigger
    guess_max = guess_log(end);

elseif player_ans == n_smaller
    guess_min = guess_log(end);

end

guess_num = randi([guess_min, guess_max]);
guess_log(end+1) = guess_num;

end

%% 숫자 추측 function(2)
%{
    제시하는 숫자보다 크다면 그 숫자를 최솟값으로 지정하고,
    제시하는 숫자보다 작다면 그 숫자를 최댓값으로 지정한 뒤 그 중간값을 다시 제시하면 
    추측하는 값에 다가갈 수 있습니다.
    처음 게임을 시작할 때는 player_ans값이 0이기 때문에, 따로 분기를 설정하였습니다.
    다만, 시작부터 50으로 매번 게임을 시작하면 매번 똑같은 숫자들이 나올 것이 뻔하기에
    시작은 1과 100사이의 무작위 정수를 제시하는 것으로 만들어 보았습니다.
%}
function [guess_log, guess_min, guess_max, guess_num] = guess_number_2(player_ans, guess_log, guess_min, guess_max)

n_empty = 0; n_bigger = 1; n_smaller = 2; 

if player_ans == n_empty
    guess_num = randi([guess_min, guess_max]);
    guess_log(end+1) = guess_num;

elseif player_ans == n_bigger
    guess_max = guess_log(end);
    guess_num = floor(median([guess_min, guess_max]));
    guess_log(end+1) = guess_num;

elseif player_ans == n_smaller
    guess_min = guess_log(end);
    guess_num = floor(median([guess_min, guess_max]));
    guess_log(end+1) = guess_num;

end
end

%% 게임 지속여부 질문 function : 게임 지속 여부 변수 continue_game 반환
function continue_game = ask_contiue_game()
while 1
    end_message = "컴퓨터가 정답을 맞췄습니다! 게임을 계속 할까요? [yes:1 / no:2]: ";
    input_n = input(end_message);
    input_yes = 1;
    input_no = 2;
    if input_n == input_yes
        continue_game = 1;
        disp("게임을 다시 시작합니다!");
        disp("==========================================================")
        break;

    elseif input_n == input_no
        continue_game = 0;
        disp("게임을 종료합니다.")
        disp("==========================================================")
        break;

    else %에러방지
        disp("숫자 1 또는 2를 입력해 주세요!");
        continue;
    end
end
end

%% Question 2 function

function movmean = my_movmean(input, n)

len_input = length(input); %벡터의의 길이

%출력값을 저장하는 벡터 movmean, 크기가 고정되어 있으므로 nan으로 찬 벡터 형성
movmean = nan(1, len_input);

if mod(n, 2) ~= 1 || n < 1 || n > len_input
    %입력한 k 값이 짝수이거나, 1보다 작거나, input의 길이보다 크다면 에러메세지를 출력해야한다.
    error("Input must be an odd number and in the section [1, the length of vector]");
elseif ~isvector(input)
    error("input must be vector");
end
%{
    원리 설명 : 
    우리가 그룹화 하고 싶어하는 그룹의 원소 개수가 n이고, 배열의 길이가 m이라고 하자, 
    첫 원소부터 n개씩 묶어 m개의 그룹을 만든다고 가정하고, 그룹의 크기를 n개로 유지시켜야 한다고 생각하면
    결국 더 필요한 원소의 개수는 n-1개가 된다. 우리는 이 그룹의 평균을 구해야 하고 movmean처럼
    처음과 끝부분이 잘려 나가야 하기 때문에, n-1개의 값이 없는 원소를 2등분하여 각각 처음과 끝에
    추가한 뒤 그룹화를 시키면 된다. 이 함수에서 n값은 항상 홀수이기 때문에, n-1값은 항상 짝수다. 
    따라서 n-1/2개의 nan값을 벡터 처음과 끝에 추가한 뒤, 앞에서부터 3개씩 묶어 평균을 구하면 된다.
    이떄, nan값을 포함한 개수, 즉 n값 그대로 나누어 평균을 구하면 자료에 없는 0을 추가해 평균을
    구한것이나 마찬가지이므로, mean함수의 "omitnan" 옵션을 사용하여 nan값을 제외한 평균을 구한다.
%}

n_nan = (n-1)/2;

vec_nan = nan(1, n_nan);
vec_for_calc = [vec_nan, input, vec_nan]; %nan값을 추가한, 계산을 위한 벡터

for idx = 1:len_input
    range_calc = idx + n - 1;
    movmean(idx) = mean(vec_for_calc(idx:range_calc), "omitnan");
end

end