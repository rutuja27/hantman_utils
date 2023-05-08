jab = '/groups/branson/home/patilr/hantman_mdays/M173_20150417.jab';
in_jab_file = '/groups/branson/home/patilr/hantman_mdays/Liftm173_Chewm173_Atmouthm173_Handopenm173_Grabm173_Supm173.jab'; % jab file to add exp/labels.
out_jab_file ='/groups/branson/home/patilr/hantman_mdays/Liftm173_Chewm173_Atmouthm173_Handopenm173_Grabm173_Supm173_out.jab'; % jab file to add exp/labels.


Q = loadAnonymous(jab);
nCls = numel(Q.classifierStuff.params);

% new jab file w/o labels/exps
jab1 = load(in_jab_file,'-mat');

% jab1.x.featureLexicon.st = struct();
% jab1.x.file.stfeatures = 'features.mat';
%jab1.x.windowFeaturesParams = repmat({Q.windowFeaturesParams},nCls,1);

jab1.x.expDirNames = Q.expDirNames;
% labels
for i = 1:numel(Q.labels)
  nfly = numel(Q.labels(i).flies);
  jab1.x.labels(i).imp_t0s = cell(1,nfly);
  jab1.x.labels(i).imp_t1s = cell(1,nfly);
end


saveAnonymous(out_jab_file,jab1);
