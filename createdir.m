
jabfile = '/nrs/branson/jab_experiments/M277PSAMBpn/FinalJAB/M277_20181005_convert.jab';
jd = loadAnonymous(jabfile);
filepaths = jd.expDirNames;

for i = 119:numel(filepaths)
    %mkdir(strcat(filepaths{i},'/cuda_dir/postprocessed/cuda_vis/'),'Lift');
    %[status, msg, msgID] = movefile(strcat(filepaths{i},'/cuda_dir/postprocessed/cuda_scores'),strcat(filepaths{i},'/cuda_dir/postprocessed/cuda_vis'));
    copyfile('/groups/branson/bransonlab/kwaki/forrutuja/predict_chew.html',strcat(filepaths{i} ,'/cuda_dir/postprocessed/cuda_vis/'));
    %[status, msg, msgID] = rmdir(strcat(filepaths{i},'/cuda_dir/postprocessed/cuda_vis/Lift'),'s');
end