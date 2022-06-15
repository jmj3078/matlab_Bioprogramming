clc; clear;
A = [ 1 2 3 4 5 6 7 8 9];
my_movmean(A,5)
movmean(A,5)


function movmean = my_movmean(input, n)

vec_input = input(:)'; %행렬에도 적용할 수 있도록 벡터로 변환
len_input = length(vec_input); %변환한 벡터의 의 길이

%출력값을 저장하는 벡터 movmean, 크기가 고정되어 있으므로 nan으로 찬 벡터 형성
movmean = nan(1, len_input);

if mod(n, 2) ~= 1 || n < 1 || n > len_input
    %입력한 k 값이 짝수이거나, 1보다 작거나, input의 길이보다 크다면 에러메세지를 출력해야한다.
    error_str = ["n argument must be odd number, and must be in section [1,", len_input,"]"];
    disp(error_str);
    return; %깔끔하게 오류 결과를 보이기 위해 error대신 return사용

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
vec_for_calc = [vec_nan, vec_input, vec_nan] %nan값을 추가한, 계산을 위한 벡터


for idx = 1:len_input
    range_calc = idx + n - 1;
    movmean(idx) = mean(vec_for_calc(idx:range_calc), "omitnan");
end

end