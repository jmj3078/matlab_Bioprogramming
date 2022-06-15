clc; clear;
%% loading files, max projection
load('ori_stimuli.mat');
inf = imfinfo("Calcium_imaging_data_int8.tif");
img_size = [inf(1).Height, inf(1).Width];
frame_num = numel(inf);

img = zeros(img_size(1), img_size(2), frame_num, 'uint8');
for ii = 1:frame_num
    img(:,:,ii) = (imread("Calcium_imaging_data_int8.tif", ii));
end
%max projection
MIP = max(img, [], 3);
MIP = im2double(MIP);
%% adaptive thresholding, image operation
%대비상승
MIP_adj = imadjust(MIP);

%adaptive thresholding 
thr = 0.01;
method = adaptthresh(MIP_adj, thr);
MIP_bin = imbinarize(MIP_adj, method);

step1 = imfill(MIP_bin, 4, 'holes');

se_1 = strel('disk', 1, 0);
se_2 = strel('disk', 2, 0);
se_3 = strel('disk', 3, 0);

step2 = imopen(step1, se_2);   

step3 = imdilate(~step2, se_1);

step4 = imreconstruct(~step3, step1);

step5 = imopen(step4, se_3);

step6 = imerode(~step5, se_1);

targets = ~step6;

figure('Name','montage'); clf;
montage({MIP, MIP_adj, MIP_bin, step2, step3, step4, step5, step6, targets})

%하나의 셀이 가운데가 끊어지는 현상이 발생됨 : imfill사용으로 해결
%겹치는 세포는 없도록 하되 다소 rough하게 roi 설정
%% marking target neurons 1)
CC = bwconncomp(targets);
id_label = zeros(size(targets), "double");
roi_list = CC.PixelIdxList;
roi_num = numel(roi_list);

for ii = 1:roi_num
    idx = roi_list{ii};
    id_label(idx) = ii;
end

%1차 target 확인
L = labeloverlay(double(MIP_adj), id_label);

figure('Name','targets overlay - total cells'); 
clf;
imshow(L, InitialMagnification=300);

%target text
cent = regionprops(CC, "Centroid");
cent_idx = [cent.Centroid];
cent_idx = reshape(cent_idx, 2, numel(cent_idx)/2)';
texts = {};
for ii = 1:roi_num
    texts{ii} = num2str(ii);
end

hold on
text(cent_idx(:, 1), cent_idx(:, 2), texts, 'Color','red','FontSize',12);
hold off
%% F and dF value calculation
roi_idx = {};

F = zeros(frame_num, roi_num);
for ii = 1:frame_num
    for jj = 1:roi_num
      [x, y] = ind2sub([img_size(1), img_size(2)],roi_list{jj});
      roi_idx{jj} = [x, y];
      %roi size : 해당 pixel의 수, roi의 크기로 나눔
      roi_size = numel(roi_idx{jj})/2;
      %pixel intensity : pixel에 해당하는 값의 합
      F(ii,jj) = sum(img(roi_idx{jj},ii))/roi_size;
    end
end

F0 = median(F); 

dF = (F-F0);

dFF_all = dF./F0;
%%
x = 1:frame_num;
figure;

subplot(2, 1, 1);
plot(x, dFF_all);

ylabel('dF/F');
xlabel('frame');
xlim([0, 1008]);
title('time-course response, 1008 frames');
legend;

%target cell의 설정 : 전체에서 낮은 활성도를 보이는 곳은 제외
%dFF_all의 max값 확인 
subplot(2, 1, 2);
plot(max(dFF_all));
title('max pixel intensity of ROIs');
xlabel('cell');
xlim([0, roi_num]);
%% target filtering : max intensity가 2가 넘는 cell들을 대상으로 진행
dFF = dFF_all(:, max(dFF_all) > 2.0);
%3.0이 넘는 활성도를 가진 roi 필터링

%roi_list, roi_num 갱신
target_list = roi_list(max(dFF_all > 2.0));
target_num = numel(target_list);

%% 2차 target 확인 - target cells

id_label = zeros(size(targets), "double");

for ii = 1:target_num
    idx = target_list{ii};
    id_label(idx) = ii;
end

L = labeloverlay(double(MIP_adj), id_label);

figure('Name','targets overlay - target cells'); 
clf;
imshow(L, InitialMagnification=300);

CC = bwconncomp(id_label);

cent = regionprops(CC, "Centroid");
cent_idx = [cent.Centroid];
cent_idx = reshape(cent_idx, 2, numel(cent_idx)/2)';
texts = {};
for ii = 1:target_num
    texts{ii} = num2str(ii);
end

hold on
text(cent_idx(:, 1), cent_idx(:, 2), texts, 'Color','red','FontSize',12);

%% time-course response 시각화 - target cells
figure;

hold on
for ii = 1:target_num
    plot(dFF(:,ii));
end
hold off

ylabel('dF/F');
xlabel('frame');
xlim([0, 1008]);
title('time-course response, 1008 frames');
legend;
%% 4
% 세트당 3.5초동안은 아무것도 보여주지 않음 / 처음 시작 후 3.5초는 삭제하는 것이 맞다.
%1008/240*3.5 = 14.7
%처음부터 15프레임에 해당하는 값은 삭제
% 총 240초, 3.5초 휴지 / 1.5초 자극
% 5초(방향당 자극) * 16회(방향 수) * 3회(세트) = 240초
% 방향 1번당 21번의 데이터가 담겨 있음
figure; 
plot(Orientation);
xlim([0, 1008]);
%수직선에 해당하는 부위가 각 자극에 해당한다.
%% 총 16방향별 3세트 시행, 방향에 해당하는 평균 값 계산
% 약 15프레임 동안은 회색 노출
% 약 6프레임 동안은 방향성 자극 노출
% 방향을 바꿔가며 16번 자극, 총 3세트 진행
% 1세트 : 1~366 프레임, 2세트 : 337 ~ 672 프레임, 3세트 : 673 ~ 1008프레임
% 자극 1회 : 21프레임, 21 * 16번 진행

ori_num = 16;
range_stm = 21;
range_set = range_stm * ori_num;
[ori , sort_idx] = sort(unique(Orientation, 'stable'));
ori_result = ori_result(sort_idx, :);

set1 = dFF(1:range_set,:);
set2 = dFF(range_set+1:range_set*2,:);
set3 = dFF(range_set*2+1:range_set*3,:);

set_mean = (set1+set2+set3)/3;

ss = 1:range_stm:range_set+1;

ori_mean = zeros(range_stm, target_num, ori_num);
for ii = 1:ori_num
    ori_mean(:,:,ii) = set_mean(ss(ii):(ss(ii+1)-1), :, :);
end
%% 21프레임에 대한 세트별 평균 response 시각화
% 1~15프레임은 아무 자극도 없으나 작더라도 peak가 존재할 수 있음을 확인
figure;
plot(ori_mean(:,:,1));
title("1 to 21, average response")
xlim([1, 21])
ylabel('dF/F');
xlabel('frame');
%% 방향별 최대 dF/F 전후 5개 point를 평균으로 방향 reponse activity값으로 설정

%세포별, 방향에 대한 response값 중 최댓값 5개 평균을 계산
%총 16개 방향에 대해 계산 후 세포 총 11개에 대해 반복
%아무 자극이 주어지지 않는 구간에서
%최댓값이 나올 수 있으므로 21개 중 초반 15프레임을 제외한 6프레임에 대해 실시

ori_mean_eff = ori_mean(15:21,:,:);
ori_result = zeros(ori_num, target_num);

for jj = 1:target_num
    for ii = 1:ori_num
        ori_result(ii, jj) = mean(maxk(ori_mean_eff(:,jj,ii), 5));
    end
end

%ori_result : 11개의 세포별(열) 16방향에 대한 최대 5개 값의 평균(행)이 저장된 데이터
%% OSI calculation 
% calculation 이전에 Orientation을 오름차순으로 설정해야 할 필요가 있음
% orientation : 225 > 45 > 180 > 67.5 > 315 > .. 식으로 진행
% 22.5 > 45 > .. > 337.5 > 360으로 진행되도록 정렬

OSI = zeros(target_num, 1);
DSI = zeros(target_num, 1);

for ii = 1:target_num
    response = ori_result(:,ii);
    pref_idx = find(response == max(response));
    if pref_idx+8 > 16
        opp_idx = pref_idx-8;
    else
        opp_idx = pref_idx+8;
    end

    if pref_idx+4 > 16
        orth_idx1 = pref_idx-12;
    else
        orth_idx1 = pref_idx+4;
    end

    if pref_idx-4 < 1
        orth_idx2 = pref_idx+12;
    else
        orth_idx2 = pref_idx-4;
    end
    
    pref = response(pref_idx);
    opp = response(opp_idx);
    orth = mean([response(orth_idx1), response(orth_idx2)]);
    
    DSI(ii) = (pref-opp)/(pref+opp);
    OSI(ii) = (pref-orth)/(pref+orth);
    %orientation values 
end

high_pref_idx = find(OSI >= 0.5);
high_pref_idx = sort(high_pref_idx);
%% linear figure : total cell
figure; 
plot(ori, ori_result);

title('Average response of total cells, for each orientations');
ylabel('dF/F');
xlabel('Orientation');
xtickformat('%g°')
xlim([22.5, 360])
legend;
%% polarplot figure

figure;

for ii = 1:numel(high_pref_idx)
    subplot(3,5,ii);
    idx = high_pref_idx(ii);
    name = sprintf('#CELL %d : OLS : %.2f, DSI : %.2f', idx, OSI(idx), DSI(idx));
    polarplot(ori_result(:,idx));
    title(name);
    figname = sprintf('#CEll %d.png', idx);

end


