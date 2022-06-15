%%
close all;
clear; clc;

v = VideoReader('Gr39b_GCaMP6s_10mM_QUI_08.m4v');
% v = VideoReader('Gr39b_GCaMP6s_10mM_CAF_08.m4v');

fluorescence = zeros(1,v.NumFrames);

% while hasFrame(v)
for ii = 1 : v.NumFrames

    frame = readFrame(v);
    imshow(frame, 'InitialMagnification', 2000);
    
    R = frame(:,:,1);
    G = frame(:,:,2);
    B = frame(:,:,3);

	fluorescence(ii) = sum([R(:); G(:); B(:)]);

end

%%
k_bin = 21; 

figure(1);
t = (1:v.NumFrames) / v.NumFrames * v.Duration; 
plot(t, fluorescence);

f = movmean(fluorescence, k_bin);

hold on; 
plot(t, f, 'LineWidth', 3, 'color', [0.5 0.5 0.5]); 


%%

close all; 
figure(1);

f = fluorescence+100; 

k_bin = 121;

f0 = movmedian(f, k_bin);

subplot(1,2,1);
plot(t, f);
hold on; 
plot(t, f0, 'LineWidth', 2, 'color', [0.5 0.5 0.5]); 

subplot(1,2,2);

deltaF_over_F = (f-f0) ./ f0;
plot(t, deltaF_over_F);

