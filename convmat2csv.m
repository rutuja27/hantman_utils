jabfile = '/groups/branson/home/patilr/hantman_data/cuda_hoghof/forRutuja/Chewm173_out.jab';
jd = loadAnonymous(jabfile);
filepaths = jd.expDirNames;

for i = 1:numel(filepaths)
    
    fname = fullfile(filepaths{i},'features.mat');
    f = load(fname);
    dlmwrite(fullfile(filepaths{i},'features.csv'),f.curFeatures);
end
