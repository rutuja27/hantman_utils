local_jabfile = '/groups/branson/home/patilr/hantman_data/gndtruth_mouse_features/forRutuja/M173_20150423.jab';    %%hantmanM173_20150420/cuda_hoghof/M173_20150420.jab';
jd = loadAnonymous(local_jabfile);
filepaths = jd.expDirNames;

for i = 1:numel(filepaths)
    
   curFeatures = load(strcat(filepaths{i},'/f1.mat')); 
   curFeatures = curFeatures.curFeatures(:,4001:8000);
   assert(~exist(strcat(filepaths{i},'/features.mat')),'Features.mat exists');
   save(strcat(filepaths{i},'/features.mat'),'curFeatures')    
end    