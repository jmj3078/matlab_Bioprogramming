clc; clear;
%% Question 1
I = imread('zebra.tif');
FI_cell= cell(1,16);

for ii = 3:2:9
   
    fi_max = ii^2;
    fi_med = ceil(ii^2/2);
    % prof comment: 결과는 같지만, 홀수라는 점을 이용 (1+ii^2)/2 로 하는 것이 정확. 
    fi_min = 1;
    
    fs = ii;
    
    filter = ones(fs,fs);
    %maximum filter
    FI_max = ordfilt2(I, fi_max, filter);
    %median filter
    FI_med = ordfilt2(I, fi_med, filter);
    %minimum filter
    FI_min = ordfilt2(I, fi_min, filter);
    
    idx = (ii-1)/2;
    FI_cell{idx*4-3} = I;
    FI_cell{idx*4-2} = FI_max;
    FI_cell{idx*4-1} = FI_med;
    FI_cell{idx*4} = FI_min;

end
figure('Name','Max, Median, Min filter / filter size : 3, 5, 7, 9')
clf;
montage(FI_cell(:)', 'Size', [4,4]);

% filter 크기가 커질 수록 대치되는 픽셀의 크기가 커지며 해상도가 낮아지고 
% 사용하는 필터의 효과가 강해진다.

% maximum filter : 흰색 영역의 확장, 검은색 영역의 축소
% 가장 큰 값(흰색에 가까움)으로 픽셀을 대치하므로 흰색 영역이 확장된다
% 필터가 커질 수록 흰색 영역이 더 확장되고 이미지의 해상도가 낮아진다.

% minimum filter : 검은색 영역의 확장, 흰색 영역의 축소
% 가장 작은 값(검은색에 가까움)으로 픽셀을 대치하므로 검은색 영역이 확장된다
% 필터가 커질 수록 검은색 영역이 더 확장되고 이미지의 해상도가 낮아진다.

% median filter : 주변 픽셀을 중앙값으로 대치하므로, 노이즈가 있는 부분의 픽셀 값이 
% 주변에 있는 색과 함께 계산되고 중화되어 이미지의 노이즈가 없어지는 효과를 가져온다.
% 필터가 커질 수록 노이즈가 더 많이 없어지고 이미지의 해상도가 낮아진다.

% prof comment: good. 60

%% Question 2
AT3 = imread('AT3_1m4_01.tif'); 

thr = 0.45;
method = adaptthresh(AT3, thr, "ForegroundPolarity", "dark");
AT3_bin = imbinarize(AT3, method);

CC = bwconncomp(AT3_bin);
cent = regionprops(CC, 'Centroid');

%좌표저장
centroids = cat(1, cent.Centroid);

%이미지 출력
figure('Name','AT3_bwconncomp'); clf;
imshow(AT3_bin);

%scatter plot 사용하여 중심에 *표시 
hold on
scatter(centroids(:,1), centroids(:,2), 'r*')
hold off

% prof comment: CC는 검은 바탕에 흰 물체를 기준으로 물체를 찾음 
% prof comment: * 위치를 자세히 관찰한다면 문제를 깨달을 수 있음 
% prof comment: adaptthresh에서 흰 바탕에 검은 물체를 얻었다면 이미지를 반전하여 CC를 적용 (-20)
% prof comment: 60 - 20 = 40 

%% Question 3
J = ~AT3_bin;

% dilate : 작은 SE를 사용하여, 세포들끼리 합쳐지거나 노이즈가 너무 커지지 않을 정도로 전경 픽셀을 확장
se_1 = strel("disk", 1, 0);
JD = imdilate(J, se_1);

% close : 적당히 큰 SE를 사용해 넓은 빈칸을 매꿀 수 있도록 조절
se_2 = strel('disk', 5, 0);  
JC = imclose(JD, se_2);     

% open : 큰 SE를 사용해 모든 노이즈와 세포 주변에 튀어나온 돌기 부분, 우상단 세포의 연결부위 제거
se_3 = strel('disk', 16, 0);  
JO = imopen(JC, se_3);

% erosion : 원하는 5개 세포의 전경만 흔적을 넘길 수 있도록 함, 상대적으로 작은 
% 구석에 있는 세포들을 없에기 위해 큰 값의 SE사용
se_4 = strel('disk', 18, 0);
JE = imerode(JO, se_4);     

%reconstruction : 남긴 흔적 JE를 출발점으로 하여, 전경의 크기를 JO만큼 확장시켜 복원 
JR = imreconstruct(JE, JO);

%원본과의 overlay를 통한 결과 비교 : 5개 세포 복원
JL = labeloverlay(AT3, JR);

%한번에 필터링 결과를 확인하면서 SE값 조정
figure('Name','origin, adaptive, dilation, closing, opening, erosion, reconstruction, result'); 
clf;
montage({AT3, J, JD, JC, JO, JE, JR, JL})


% prof comment: 세포의 형태 잘 살렸고 잡음을 잘 제거하여 원하는 세포만 잘 살렸음. 
% prof comment: great. 90

%%
% 60 + 40 + 90 = 190

