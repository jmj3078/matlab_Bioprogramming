
file_1 = 'pse_L2_50mM_NaCl_01.txt';
file_2 = 'sim_L7_50mM_NaCl_01.txt';

ap_record = cell(1,2);
data_temp = importdata(file_1);
ap_record{1} = data_temp.data; 
data_temp = importdata(file_2);
ap_record{2} = data_temp.data; 

close all;
figure(1);
subplot(2, 1, 1);
plot(ap_record{1}(:,1), ap_record{1}(:,2));
xlim([0.9 2.1])
subplot(2, 1, 2);
plot(ap_record{2}(:,1), ap_record{2}(:,2));
xlim([0.9 2.7])

%%
figure(2);

for ii = 1 : 2
    subplot(2, 1, ii);
    findpeaks(ap_record{ii}(:,2), ap_record{ii}(:,1), ...
                            'MinPeakHeight', 7000, ...
                            'MinPeakProminence', 15000, ...
                            'Annotate', 'extent');
    xlim([0.9 3.0]);
end

%%
figure(3);
freq = zeros(1, 2); 
for ii = 1 : 2
    [pks, times, w, p] = findpeaks(ap_record{ii}(:,2), ap_record{ii}(:,1), ...
                            'MinPeakHeight', 7000, ...
                            'MinPeakProminence', 15000, ...
                            'Annotate', 'extent');

    subplot(2, 1, ii);
    scatter(times(1:end-1), diff(times))                % time between two spikes 
    freq(ii) = numel(times) / (times(end)-times(1));    % spiking frequency (firing rate)
end

