local_jabfile = '/nrs/branson/jab_experiments/M277PSAMBpn/FinalJAB/M277_20181005_convert.jab'; %'/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423_convert.jab';

%% create JLabelData for train data

groundTruthingMode=false;
data = JLabelData('setstatusfn',@fprintf_wrapper,'clearstatusfn',@() fprintf('Done.\n'));
data.openJabFile(local_jabfile,groundTruthingMode);
Q = loadAnonymous(data.everythingFileNameAbs);

cuda_t0s = load('/nrs/branson/jab_experiments/M277PSAMBpn/cuda_postprocess_20181005/ppdata_20181005.mat');
matlab_t0s = load('/nrs/branson/jab_experiments/M277PSAMBpn/matlab_postprocess_20181005/ppdata_20181005.mat');

labels = data.labels(119).names{1};
id = find(strcmp(data.labels(119).names{1},'Liftm134w'));
gnd_Lift = []; gnd_Handopen = []; gnd_Grab = []; gnd_Sup = []; gnd_Atmouth = []; gnd_Chew = [];
if(~isempty(id)) gnd_Lift = data.labels(119).t0s{1}(id); end

id = find(strcmp(data.labels(119).names{1},'Handopenm134w'));
if(~isempty(id)) gnd_Handopen = data.labels(119).t0s{1}(id); end

id = find(strcmp(data.labels(119).names{1},'Grabm134w'));
if(~isempty(id)) gnd_Grab = data.labels(119).t0s{1}(id); end

id = find(strcmp(data.labels(119).names{1},'Supm134w'));
if(~isempty(id)) gnd_Sup = data.labels(119).t0s{1}(id); end

id = find(strcmp(data.labels(119).names{1},'Atmouthm134w'));
if(~isempty(id)) gnd_Atmouth = data.labels(119).t0s{1}(id); end

id = find(strcmp(data.labels(119).names{1},'Chewm134w'));
if(~isempty(id)) gnd_Chew = data.labels(119).t0s{1}(id); end


figure
%subplot(6,1,1)
stem(cuda_t0s.data(119).auto_Lift_t0s,'Marker','o','MarkerFaceColor','b');
hold on;
stem(matlab_t0s.data(119).auto_Lift_t0s,'Marker','o','MarkerFaceColor','r');
hold on;
stem(gnd_Lift,'Marker','o','MarkerFaceColor','g');

% subplot(6,1,2)
% plot(cuda_t0s.data(119).auto_Handopen_t0s,'Marker','o','MarkerFaceColor','b');
% hold on;
% plot(matlab_t0s.data(119).auto_Handopen_t0s,'Marker','o','MarkerFaceColor','r');
% hold on;
% plot(gnd_Handopen,'Marker','o','MarkerFaceColor','g');


% subplot(6,1,3)
% plot(cuda_t0s.data(119).auto_Grab_t0s,'Marker','o');
% hold on;
% plot(matlab_t0s.data(119).auto_Grab_t0s,'Marker','o');
% hold on
% plot(gnd_Grab,'Marker','o','Color','g');
% 
% subplot(6,1,4)
% plot(cuda_t0s.data(119).auto_Sup_t0s,'Marker','o');
% hold on;
% plot(matlab_t0s.data(119).auto_Sup_t0s,'Marker','o');
% hold on;
% plot(gnd_Sup,'Marker','o','Color','g');
% 
% 
% subplot(6,1,5)
% plot(cuda_t0s.data(119).auto_Atmouth_t0s,'Marker','o');
% hold on;
% plot(matlab_t0s.data(119).auto_Atmouth_t0s,'Marker','o');
% hold on;
% plot(gnd_Atmouth,'Marker','o','Color','g');
% 
% subplot(6,1,6)
% plot(cuda_t0s.data(119).auto_Chew_t0s,'Marker','o');
% hold on;
% plot(matlab_t0s.data(119).auto_Chew_t0s,'Marker','o');
% hold on;
% plot(gnd_Chew,'Marker','o','Color','g');

