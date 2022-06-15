clear ; clc;
%% Question 1
k = input("Enter an integer bigger or equal to 1: ");
pascal_tri(k);

%% Question 2
%짧은 숫자 작동 확인
disp("----------------------------------------------------");
short_sample1 = str2double(long_sum('41440','98424'));
short_sample2 = 41440 + 98424;

disp("short sample : ");
disp([short_sample1, short_sample2]);
disp(isequal(short_sample1, short_sample2));

%긴 숫자 작동 확인
long_sample1 = str2double(long_sum('19823918723918237912819283','9238493942834928349'));
long_sample2 = 19823918723918237912819283 + 9238493942834928349;

disp("long sample : ");
disp([long_sample1, long_sample2]);
disp(isequal(long_sample1, long_sample2));

%2^64-1이 넘는 숫자의 계산
longlong_sample1 = long_sum('9999999999999999999999999999999999999999999','1');
longlong_sample2 = long_sum('8572938572938579238598710201983019284019205123','192419257819287498172948719284912856918259182123');
ans1 = '10000000000000000000000000000000000000000000';
ans2 = '200992196392226077411547429486895876202278387246';

disp("longlong sample : ")
disp(longlong_sample1);
disp(longlong_sample2);
disp(isequal(longlong_sample1, ans1));
disp(isequal(longlong_sample2, ans2));

%% Question 3-1
disp("----------------------------------------------------");

s1='GAGCCTACTAACGGGAT';
t1='CATCGTAATGACGGCCT';

disp("Counting point mutation :")
disp(Count_Point_Mutation(s1,t1));

%% Question 3-2
s2='GCAACGCACAACGAAAACCCTTAGGGACTGGATTATTTCGTGATCGTTGTAGTTATTGGAAGTACGGGC ATCAACCCAGTT';
t2='TTATCTGACAAAGAAAGCCGTCAACGGCTGGATAATTTCGCGATCGTGCTGGTTACTGGCGGTACGAGT GTTCCTTTGGGT';

disp("transition/transversion ratio : ");
disp(Transition_Transversion_ratio(s2, t2));

%% Question 1 function

function pascal_tri(k)
 
%입력값을 정수형태로 변경/반올림
k = int16(k);

%입력값이 1 미만일 경우 오류 출력
if k < 1 
    error("Input must be bigger or equal to 1");
end

%(k, k)크기의 빈 행렬을 만들고 파스칼 삼각형에 대응하는 숫자를 삽입
mtx_pascal = zeros(k);

for ii = 1:k
    %양 끝은 항상 1
    mtx_pascal(ii,[1,ii]) = 1;

    %세번째 줄 부터 규칙을 활용해 표현 가능( nCk = n-1Ck-1 + n-1Ck )
    if ii >= 3
        for jj = 2:ii-1
            mtx_pascal(ii,jj) = mtx_pascal(ii-1,jj-1) + mtx_pascal(ii-1,jj);
        end
    end
    
    %행 별로 추출하여 숫자 0제거한 뒤, string으로 변환하고 join함수를 활용해서 
    %공백을 일정하게 넣어줍니다.(바로 int2str로 변환하면 공백이 들쑥날쑥해짐)
    row_pascal = mtx_pascal(ii,:);
    row_pascal(row_pascal == 0) = [];
    
    if ii>= 6
        row_pascal = join(string(row_pascal),'  ');
    else
        row_pascal = join(string(row_pascal),'   ');
    end

    %특정 길이의 공백을 반환하는 blank함수의 활용
    blank = blanks(2*(k-ii));
    disp(blank + row_pascal);
end

end
%% Question 2 function

function sum_result = long_sum(a,b)

%연산을 편리하고 직관적이게 하기 위해, 주어진 숫자를 뒤집어서 사용
%덧셈은 1의 자리부터 시작해 위로 올라가는 구조, 뒤집어서 사용하면 좀 더 직관적으로 접근 가능
a = a(end:-1:1);
b = b(end:-1:1);

%자릿수가 긴 숫자와 짧은 숫자를 지정
if length(a) > length(b)
    num_long = a;
    num_short = b;
else
    num_long = b;
    num_short = a;
end

len_long = length(num_long);
len_short = length(num_short);

carrier = 0; %단위별 계산하여 10이 넘을 경우, 자리올림을 위한 값을 저장해 두는 변수
ii = 0; %인덱스 값이자, 접근하는 자릿수를 나타내는 변수

while 1
    ii = ii+1;
    
    %자릿수에 해당하는 숫자가 모두 있는 경우
    if ii <= len_short

    dl = str2double(num_long(ii));
    ds = str2double(num_short(ii));

    sum_digit = dl + ds + carrier;
    sum_result(ii) = num2str(rem(sum_digit, 10));
    carrier = fix(sum_digit/10);  
    
    %자릿수에 해당하는 숫자가 큰 숫자 하나인 경우
    elseif ii <= len_long
    
    dl = str2double(num_long(ii));

    sum_digit = dl + carrier;
    sum_result(ii) = num2str(rem(sum_digit,10));
    carrier = fix(sum_digit/10);

    %더이상 자릿수에 해당하는 숫자가 없는 경우
    %자리올림을 해 줘야 하는 경우 1을 더해주고 반복문을 끝내고, 그렇지 않은 경우 그냥 끝낸다.
    elseif ii == len_long+1
        if carrier == 1
            sum_result(ii) = num2str(carrier);
        end
        break;
    end

end

%문자열을 다시 뒤집으면 원하는 덧셈 결과 반환
sum_result = sum_result(end:-1:1);

end

%% Question 3 function - 1

function Ham_Dist = Count_Point_Mutation(s,t)

%입력값이 char자료형이 아닐 경우 에러 출력 
if ~all(ischar([s,t]))
    error("arguments must be char");
end
num_bp = numel(s);

Ham_Dist = 0;
for ii = 1:num_bp
    Ham_Dist = Ham_Dist + ~isequal(s(ii),t(ii));
end
end

%% Question 3 function - 2

%transition : A-G 또는 C-T 변환
%transversion : A-C,T G -C,T 또는 C - A,G T-A,G 변환

function ratio = Transition_Transversion_ratio(s,t)

%입력값이 char가 아닐 경우 에러 출력
if ~all(ischar([s,t]))
    error("arguments must be char");
end

num_bp = numel(s);
transition = 0;
tranversion = 0;
purine = 'AG';
pyrimidine = 'CT';

for ii = 1:num_bp
    if ~isequal(s(ii),t(ii))
        if all(ismember([s(ii),t(ii)],purine)) || all(ismember([s(ii),t(ii)],pyrimidine))
            transition = transition + 1;
        else
            tranversion = tranversion + 1;
        end
    end
end

ratio = transition / tranversion;
end






