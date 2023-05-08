addpath /groups/branson/home/patilr/JAABAST/miceCode
addpath /groups/branson/home/patilr/JAABAST/miceCode/pdollarOF

%% load jabfile 

local_jabfile = '/groups/branson/home/patilr/hantman_data/forRutuja/M173_20150423.jab';
jd = loadAnonymous(local_jabfile);
filepaths = jd.expDirNames;

%% cpy_files into given folder for multiple folders

for i=2:numel(filepaths)

    rootfile = dir(fullfile(filepaths{i}));
    mv_folder = strcat(filepaths{i},'/gpu_scores');
    for ndx =1:numel(rootfile)
       curd = fullfile(fullfile(filepaths{i}),rootfile(ndx).name);
       if isdir(curd)
           continue;
       elseif(strcmp(rootfile(ndx).name(1:6),'scores'))
            movefile(curd,mv_folder);
       end          
    end
end