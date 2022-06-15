clc; clear; 
%% Question 1
black_double = zeros(499, 499, "double");

%점 250,250과 거리가 249보다 작거나 같은 좌표를 1로 만든다.
for ii = 1:499
    for jj = 1:499
        if (250-ii)^2+(250-jj)^2 <= 249^2 
            black_double(ii, jj) = 1;
        end
    end
end
figure; clf; imshow(black_double);

% prof comment: 0/1 로만 된 이미지를 만드려면 'logical' 형식이 더 적절. 결과는 같음. 
% prof comment: for 사용을 줄이려는 노력을 해보기. 
% prof comment: 250, 499, 등의 반복 사용되는 숫자는 변수에 저장해서 사용 

%% Question2
AT3 = imread('AT3_1m4_01.tif'); 

%sensitivity 는 0부터 1까지의 값, 0.05부터 1.00까지 20개의 figure을 비교
%전경픽셀(이진화를 할 픽셀)으로 간주할 픽셀을 검정으로 설정한다. 
%ensitivity가 높을수록 더 넓은 범위의 회색을 전경픽셀로 간주해 검정으로 변환한다.
%sensitivity가 너무 낮으면 전경이 분리가 잘 되지 않고, 너무 높으면 배경과 구별이 되지 않는다.

BW_1 = cell(1,20);

for ii = 1:20
   thr = ii*(0.05);
   method = adaptthresh(AT3, thr, "ForegroundPolarity", "dark");
   %adaptthresh로 주어진 이진화 방법을 통해 AT3 이진화 이미지 생성 : imbinarize
   BW_1{ii} = imbinarize(AT3, method);    
end

%예제의 경우 sensitivity가 0.75~0.80일때 세포 테두리 부분을 잘 분리하는 경향을 보인다.
figure;
clf;
montage([{AT3} BW_1(:)'], "Size", [3 7]);

%% 
BW_2 = cell(1,20);

%option : "bright" 전경픽셀으로 간주할 픽셀을 흰색으로 설정한다. 
%sensitivity가 높을수록 더 넓은 범위의 회색을 전경픽셀로 간주해 검정으로 변환한다. 
%sensitivity가 너무 낮으면 전경이 분리가 잘 되지 않고, 너무 높으면 배경과 구별이 되지 않는다.

for ii = 1:20
   thr = ii*(0.05);
   method = adaptthresh(AT3, thr, "ForegroundPolarity", "bright");
   %adaptthresh로 주어진 이진화 방법을 통해 AT3 이진화 이미지 생성 : imbinarize
   BW_2{ii} = imbinarize(AT3, method);    
end

%이 경우 sensitivity가 0.25 ~ 0.40일때 세포 테두리 부분을 잘 분리하는 경향을 보인다.
figure;
clf;
montage([{AT3} BW_2(:)'], "Size", [3 7]);


% prof comment: 높은 sensitivity, dark = 낮은 sensitivity bright 

%%
% prof comment: 40 + 60 = 100
