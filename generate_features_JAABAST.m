addpath /groups/branson/home/patilr/JAABAST/miceCode
addpath /groups/branson/home/patilr/hantman_data/scripts/

local_jabfile = '/groups/branson/home/patilr/hantman_data/gndtruth_mouse_features/forRutuja/M173_20150423.jab';
jd = loadAnonymous(local_jabfile);
filepaths = jd.expDirNames;

%% generate features hog/hof JAABAST

singleview=true;
frontside=false;
t_start = tic();
for i = 1:numel(filepaths)        
    genAllFeatures(filepaths{i},'frontside',frontside,'singleview',singleview);
end
t_elapsed = toc(t_start);


frontside = true;
for i = 1:numel(filepaths)        
    genAllFeatures(filepaths{i},'frontside',frontside,'singleview',singleview);
end

