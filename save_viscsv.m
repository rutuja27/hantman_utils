addpath ~/installed_packages/cell2csv/

local_jabfile = '/nrs/branson/jab_experiments/M277PSAMBpn/FinalJAB/M277_20181005_convert.jab';
jd = loadAnonymous(local_jabfile);
filepaths = jd.expDirNames;

ppscorefile_cuda = '/nrs/branson/jab_experiments/M277PSAMBpn/cuda_postprocess_20181005/ppscores_20181005.mat';
ppscorefile_matlab = '/nrs/branson/jab_experiments/M277PSAMBpn/matlab_postprocess_20181005/ppscores_20181005.mat';
ppscores_cuda = load(ppscorefile_cuda); 
ppscores_matlab = load(ppscorefile_matlab);

nexps = numel(filepaths);
for idx= 119:nexps
    disp(filepaths{idx});
    savelocation = strcat(filepaths{idx},'/cuda_dir/postprocessed/cuda_vis/');
    fname = 'predict_chew.csv';
    behname = 'Chewm134w';
    nframes = numel(ppscores_cuda.ppscores(idx).Chew_postprocessed);
    gnd_truth = zeros(nframes, 1);
    if(~isempty(jd.labels(idx).t0s{1})) 
        curlblnames = jd.labels(idx).names{1};
        beh_idx = find(ismember(curlblnames,behname));
        if(~isempty(beh_idx)) gnd_truth(jd.labels(idx).t0s{1}(beh_idx)) = 1; end
    end
    savevis(ppscores_cuda.ppscores(idx).Chew_postprocessed,...
            ppscores_matlab.ppscores(idx).Chew_postprocessed,...
            gnd_truth,savelocation,fname,nframes);
    
end

function savevis(scrc,scrm,gnd_truth,fpath,fname,nframe)

  cHeader = {'frame','cuda predict' ,'matlab predict', 'gnd truth','image'}; 

   %write data to end of file
  frameid = 0:nframe-1;
  frameid = string(frameid);
  img = pad(frameid,5,'left','0');
  img = strcat('frames/',img,'.jpg');
  C = [(0:nframe-1)' scrc' scrm' gnd_truth img'];
  C = [cHeader;C];
  cell2csv(strcat(fpath,fname),C);
    
end