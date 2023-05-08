
label_jab_file = '/groups/branson/home/patilr/hantman_data/cuda_hoghof/forRutuja/M173_20150423.jab'; % jab file to import exp/labels from.
in_jab_file = '/groups/branson/home/patilr/hantman_data/cuda_hoghof/forRutuja/Liftm173_Chewm173_Handopenm173_Atmouthm173_Grabm173_Supinatem173.jab'; % jab file to add exp/labels.
out_jab_file = '/groups/branson/home/patilr/hantman_data/cuda_hoghof/forRutuja/Liftm173_Chewm173_Handopenm173_Atmouthm173_Grabm173_Supinatem173_out.jab'; % jab file to add exp/labels.

% import jab
Q = loadAnonymous(label_jab_file);
nCls = numel(Q.classifierStuff.params);

% new jab file w/o labels/exps
jab1 = loadAnonymous(in_jab_file);
% 
 origExpDirNames = Q.expDirNames;
 origLabels = Q.labels;
 origBehaviors = Q.behaviors;
 origScoreFilenames = Q.file;

jab1.featureLexicon.st = struct();
jab1.file.stfeatures = 'features.mat';
jab1.windowFeaturesParams = repmat({Q.windowFeaturesParams},nCls,1);

for i = 1:numel(Q.labels)
  nfly = numel(Q.labels(i).flies);
  jab1.labels(i).imp_t0s = cell(1,nfly);
  jab1.labels(i).imp_t1s = cell(1,nfly);
end

% cs
csST = Q.classifierStuff;
for i = nCls:-1:1
  cs(i,1) = ClassifierStuff;
  cs(i,1).type = csST.type;
  %cs(i,1).params = csST.params{i};
  %cs(i,1).timeStamp = csST.timeStamp(i);
  cs(i,1).confThresholds = csST.confThresholds(2*i-1:2*i);
  cs(i,1).scoreNorm = csST.scoreNorm(i);
  cs(i,1).postProcessParams = csST.postProcessParams;
  cs(i,1).trainingParams = csST.trainingParams{i};
  assert(isempty(csST.featureNames));
  cs(i,1).featureNames = cell(1,0);
  cs(i,1).savewindowdata = csST.savewindowdata;
end
jab1.classifierStuff = cs;

jab1.behaviors = origBehaviors;
jab1.file = origScoreFilenames;
jab1.labels = origLabels;
jab1.expDirNames = origExpDirNames;

saveAnonymous(out_jab_file,jab1);

