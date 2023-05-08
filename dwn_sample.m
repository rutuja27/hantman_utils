addpath /groups/branson/home/patilr/JAABA/spaceTime/toolbox/channels
addpath /groups/branson/home/patilr/JAABA/spaceTime/adamMice/pdollarOF
addpath /groups/branson/home/patilr/JAABA/spaceTime/adamMice

local_jabfile = '/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423.jab';    
out_dir = '/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/';                           
jd = loadAnonymous(local_jabfile);
filepaths = jd.expDirNames;

for i=1:numel(filepaths)

vid_side = fullfile(filepaths{i} , 'movie_sde.avi');
vid_front = fullfile(filepaths{i} , 'movie_frt.avi');
%get video info
[readFrameFcns.side.readframe,readFrameFcns.side.nframes,readFrameFcns.side.fid,readFrameFcns.side.headerinfo] = get_readframe_fcn(vid_side);
[readFrameFcns.front.readframe,readFrameFcns.front.nframes,readFrameFcns.front.fid,readFrameFcns.front.headerinfo] = get_readframe_fcn(vid_front);
assert(readFrameFcns.side.nframes == readFrameFcns.front.nframes);

%output video
mv_frt = strcat(filepaths{i},'/movie_frt_dwnsample.avi');
mv_side = strcat(filepaths{i},'/movie_sde_dwnsample.avi');
frt_obj = VideoWriter(mv_frt);
side_obj = VideoWriter(mv_side);
frt_obj.FrameRate = readFrameFcns.front.headerinfo.FrameRate;
side_obj.FrameRate = readFrameFcns.side.headerinfo.FrameRate;
frt_obj.open();
side_obj.open();
nframes = readFrameFcns.side.nframes;

for ndx=1:nframes

    imMat.front = lclReadFrame(readFrameFcns.front,ndx,ndx,0,0);
    imMat.side = lclReadFrame(readFrameFcns.side,ndx,ndx,0,0);
    
    side_new = imresize(imMat.side,[(readFrameFcns.side.headerinfo.Height/2) (readFrameFcns.side.headerinfo.Width/2)]);
    front_new = imresize(imMat.front,[(readFrameFcns.side.headerinfo.Height/2) (readFrameFcns.side.headerinfo.Width/2)]);
    frt_obj.writeVideo(uint8(front_new));
    side_obj.writeVideo(uint8(side_new));
    
end

frt_obj.close();
side_obj.close();

end

function imMat = lclReadFrame(rff,i0,i1,do_fliplr,tfvidfile)
try
  tt = rff.readframe([i0 i1]);
catch ME,
  if strcmp(ME.identifier,'MATLAB:audiovideo:VideoReader:incompleteRead')
    fprintf('Reading Frames individually\n');
    tt = [];
    for ndx = i0:i1
      tt(:,:,:,end+1) = rff.readframe(ndx); %#ok<AGROW>
    end
  else
    rethrow(ME);
  end
end

iscolor = size(tt,3) > 1;
  
nfrm = i1-i0+1;
imMat = zeros(rff.headerinfo.Height,rff.headerinfo.Width,nfrm,'single');
  
for ndx = 1:nfrm,
  if iscolor,
    ttgraycurr = rgb2gray(tt(:,:,:,ndx));
  else
    ttgraycurr = tt(:,:,:,ndx);
  end
  if do_fliplr,
    qq = fliplr(ttgraycurr);
  else
    qq = ttgraycurr;
  end
  imMat(:,:,ndx) = single(qq);
end

if tfvidfile && rff.fid>0
  fclose(rff.fid);
end
end