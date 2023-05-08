addpath /groups/branson/home/patilr/JAABA/spaceTime/toolbox/channels
addpath /groups/branson/home/patilr/JAABA/spaceTime/pdollarOF
addpath /groups/branson/home/patilr/JAABA/spaceTime/adamMice

%filepath = '/groups/branson/home/patilr/hantman_data/cuda1/forRutuja/M173_20150423_v016';
filepath = '/nrs/branson/jab_experiments/M274Vglue2_Gtacr2_TH/20180814/M274_20180814_v002';
[vr,nframes,fid,headerinfo] = get_readframe_fcn(strcat(filepath,'/movie_comb.avi'));

%scores 
beh = 'Liftm173';
%f1='/groups/branson/home/patilr/hantman_data/cuda1/forRutuja/M173_20150423_v016/';
%f2='/groups/branson/home/patilr/hantman_data/cuda4/forRutuja/M173_20150423_v016/';
f = load('/nrs/branson/jab_experiments/M277PSAMBpn/cuda_postprocess_20181005/ppscores_20181005.mat');
m = load('/nrs/branson/jab_experiments/M277PSAMBpn/matlab_postprocess_20181005/ppscores_20181005.mat');

%scr_f1=load(strcat(f1,'scores_',beh,'.mat'));
%scr_f2=load(strcat(f2,'scores_',beh,'.mat'));
%scr_f1=scr_f1.allScores.scores{1};
%scr_f2=scr_f2.allScores.scores{1};

f= f.ppscores(119).Lift_postprocessed;
m = m.ppscores(119).Lift_postprocessed;

figure(1);
hold all;
 buttonH = uicontrol('Style', 'ToggleButton', ...
'Units',    'pixels', ...
'Position', [5, 5, 60, 20], ...
'String',   'Pause', ...
'Value',    1);

 buttonE = uicontrol('Style', 'ToggleButton', ...
'Units',    'pixels', ...
'Position', [80, 5, 60, 20], ...
'String',   'Exit', ...
'Value',    1);

 i=1;
 while i<=nframes-1000
   if get(buttonH, 'Value')==1
       plot(i:i+1000-1,f(i:i+1000-1),'r');
       plot(i:i+1000-1,m(i:i+1000-1),'b');
%      plot(i:i+50-1,scr_f3(i:i+50-1),'m');
       axis([i i+1000-1 0 2]);drawnow
   else
       w = waitforbuttonpress;
       if w == 0
           set(buttonH,'Value',1);
       end
   end
   if get(buttonE,'Value')==0
       close;
       break;
   end    
   i = i+1;
 end

