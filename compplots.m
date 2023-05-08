
%scores 
beh = 'Handopenm173';
f1='/groups/branson/home/patilr/hantman_data/gndtruth_mouse_features/forRutuja/M173_20150423_v043/';
%f2='/groups/branson/home/patilr/hantman_data/matlab_hoghof/forRutuja/M173_20150423_v009/';
f3 = '/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423_v043/';
% f4 = '/groups/branson/home/patilr/hantman_data/cuda_40x5_v4/forRutuja/M173_20150423_v009/';
% f5 = '/groups/branson/home/patilr/hantman_data/cuda_40x7/forRutuja/M173_20150423_v009/';

scr_f1=load(strcat(f1,'scores_',beh,'.mat'));
% scr_f2=load(strcat(f2,'scores_',beh,'.mat'));
scr_f3=load(strcat(f3,'scores_',beh,'.mat'));
% scr_f4=load(strcat(f4,'scores_',beh,'.mat'));
% scr_f5=load(strcat(f5,'scores_',beh,'.mat'));
% 
scr_f1=scr_f1.allScores.scores{1};
% scr_f2=scr_f2.allScores.scores{1};
scr_f3=scr_f3.allScores.scores{1};
% scr_f4=scr_f4.allScores.scores{1};
% scr_f5=scr_f5.allScores.scores{1};

%plots
figure(1)
AX=[];
AX(1) = subplot(5,1,1);
plot(scr_f1);
title('Old Features')
% AX(2) = subplot(5,1,2);
% plot(scr_f2);
% title('Matlab(40x10)')
AX(2) = subplot(5,1,2);
plot(scr_f3);
title('Cuda(40x10)')
% AX(4) = subplot(5,1,4);
% plot(scr_f4);
% title('Smaller Crop size Cuda(40x5)')
% AX(5) = subplot(5,1,5);
% plot(scr_f5);
% title('Smaller Crop size Cuda(40x7)')
suptitle('Scores for Lift Behavior Detection for Video 66')
set(AX,'YLim',[-100 100])
%legend('scr f1','scr f2','scr f3','scr f4');
