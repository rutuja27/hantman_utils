addpath /groups/branson/home/patilr/JAABA/spaceTime/toolbox/channels
addpath /groups/branson/home/patilr/JAABA/spaceTime/pdollarOF
addpath /groups/branson/home/patilr/JAABA/spaceTime/adamMice

local_jabfile = '/nrs/branson/jab_experiments/M277PSAMBpn/FinalJAB/M277_20181005_convert.jab';
                %%'/groups/branson/home/patilr/hantmanM173_20150420/cuda_hoghof/M173_20150420.jab';
jd = loadAnonymous(local_jabfile);
filepaths = jd.expDirNames;

for i=1:numel(filepaths)    
    [vr,nframes,fid,headerinfo] = get_readframe_fcn(strcat(filepaths{i},'/movie_comb.avi'));  
    mv_frt = strcat(filepaths{i},'/movie_frt.avi');
    mv_side = strcat(filepaths{i},'/movie_sde.avi');
    frt_obj = VideoWriter(mv_frt);
    side_obj = VideoWriter(mv_side);
    frt_obj.FrameRate = headerinfo.FrameRate;
    side_obj.FrameRate = headerinfo.FrameRate;
    frt_obj.open();
    side_obj.open();
    for i=1:nframes
        frame = vr(i);
        new_f1 = frame(:,1:headerinfo.Width/2,:);
        new_f2 = frame(:,headerinfo.Width/2+1:headerinfo.Width,:);
        frt_obj.writeVideo(new_f2);
        side_obj.writeVideo(new_f1);
    end
frt_obj.close();
side_obj.close();
