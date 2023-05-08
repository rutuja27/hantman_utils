%% set up paths

addpath /groups/branson/home/patilr/JAABA/spaceTime/adamMice
addpath /groups/branson/home/patilr/JAABA/perframe;
addpath /groups/branson/home/patilr/JAABA/filehandling;
addpath /groups/branson/home/patilr/JAABA/misc;

%% parameters

jabfile = '/nrs/branson/jab_experiments/M277PSAMBpn/FinalJAB/M277_20181005.jab';%'/groups/branson/home/patilr/hantman_data/cuda_dwnsample/forRutuja/M173_20150423.jab';
rootdatadir = 'Y:\Jay\Videos';%'/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/';
local_datadir = '/nrs/branson/jab_experiments/';%'/groups/branson/home/patilr/hantman_data/cuda_dwnsample/forRutuja/';
local_jabfile = '/nrs/branson/jab_experiments/M277PSAMBpn/FinalJAB/M277_20181005_convert.jab';%'/groups/branson/home/patilr/hantman_data/cuda_dwnsample/forRutuja/M173_20150423.jab';
fracframes = logspace(-2,0,20);

%% change file locations

jd = loadAnonymous(jabfile);

filepaths = jd.expDirNames;
for i = 1:numel(filepaths),
  disp(filepaths{i})
  filepaths{i} = strrep(filepaths{i},rootdatadir,local_datadir);
  filepaths{i} = strrep(filepaths{i},'\','/');
  filepaths{i} = strcat(filepaths{i},'/cuda_dir');
  disp(filepaths{i});
  assert(exist(filepaths{i},'dir')>0);
end
jd.expDirNames = filepaths;


filepaths = jd.gtExpDirNames;
for i = 1:numel(filepaths),
  filepaths{i} = strrep(filepaths{i},rootdatadir,local_datadir);
  disp(filepaths{i});
  assert(exist(filepaths{i},'dir')>0);
end
jd.gtExpDirNames = filepaths;

saveAnonymous(local_jabfile,jd);