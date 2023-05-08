label_jab_file = '/groups/branson/home/patilr/hantman_data/matlab_40x5_v4/forRutuja/M173_20150423.jab'; % jab file to import exp/labels from.
in_jab_file = '/groups/branson/home/patilr/hantman_data/matlab_40x5_v4/forRutuja/Chewm173.jab'; % jab file to add exp/labels.
out_jab_file ='/groups/branson/home/patilr/hantman_data/matlab_40x5_v4/forRutuja/Chewm173_out.jab'; % jab file to add exp/labels.

% import jab
Q = load(label_jab_file,'-mat');
assert(Q.x.behaviors.nbeh > 1,'Not a multi behavior jab');

% new jab file w/o labels/exps
jab1 = load(in_jab_file,'-mat');
jab1=jab1.x;
curbeh = 'Chewm173';

% fields to copy
origExpDirNames = Q.x.expDirNames;
origLabels = Q.x.labels;
assert(numel(origExpDirNames)==numel(origLabels));

%copy exps
jab1.expDirNames = origExpDirNames;
% jab1.behaviors.names = {curbeh,strcat('No_',curbeh)};

% copy only cur behavior labels
for i=1:numel(origLabels)
    currlabels = origLabels(i);
    if isempty(currlabels.names)
        jab1.labels(i) = currlabels;  
        continue;
    end
    currlbl_names = origLabels(i).names{1};   
    currbeh_idx_neg = find(ismember(currlbl_names,strcat('No_',curbeh)));
    currlabels.names{1}(currbeh_idx_neg) = {'None'};
    currlbl_names = currlabels.names{1};
    currbeh_idx = find(ismember(currlbl_names,curbeh) | ismember(currlbl_names,'None'));
    if isempty(currbeh_idx)
        jab1.labels(i).names = cell(1,0);
        jab1.labels(i).t0s = cell(1,0);
        jab1.labels(i).t1s = cell(1,0);
        jab1.labels(i).timelinetimestamp = cell(1,0);
        jab1.labels(i).timestamp = cell(1,0);
        jab1.labels(i).flies = zeros(0,1);
        jab1.labels(i).off = zeros(1,0);
        jab1.labels(i).imp_t0s = cell(1,0);
        jab1.labels(i).imp_t1s = cell(1,0);
        continue;
    end
    jab1.labels(i).names{1} = currlabels.names{1}(currbeh_idx);
    jab1.labels(i).t0s{1} = currlabels.t0s{1}(currbeh_idx);
    jab1.labels(i).t1s{1} = currlabels.t1s{1}(currbeh_idx);
    jab1.labels(i).flies = currlabels.flies;
    jab1.labels(i).timestamp{1} = currlabels.timestamp{1}(currbeh_idx);
    jab1.labels(i).timelinetimestamp{1}.Chewm173 = currlabels.timelinetimestamp{1}.Chewm173;
    jab1.labels(i).imp_t0s{1} = currlabels.imp_t0s{1};
    jab1.labels(i).imp_t1s{1} = currlabels.imp_t1s{1};
    jab1.labels(i).off= currlabels.off;
end
% save output jab 

saveAnonymous(out_jab_file,jab1);