addpath /groups/branson/home/patilr/JAABAST/miceCode
addpath /groups/branson/home/patilr/JAABAST/perframe;
addpath /groups/branson/home/patilr/JAABAST/filehandling;
addpath /groups/branson/home/patilr/JAABAST/misc;

%% change classifier params in the jab file acc to new feature size

jabfile = '/groups/branson/home/patilr/hantman_data/cuda_1_hoghof/forRutuja/M173_20150423.jab';
mod_jabfile = '/groups/branson/home/patilr/hantman_data/forRutuja/M173_20150423.jab';

jd = loadAnonymous(jabfile);
mod_jd = loadAnonymous(mod_jabfile);

nparams = numel(jd.classifierStuff.params);
nparams_mod = numel(mod_jd.classifierStuff.params);
assert(nparams==nparams_mod)

for i=1:nparams   
    jd.classifierStuff.params{i} = mod_jd.classifierStuff.params{i};
end
    
saveAnonymous(jabfile,jd);