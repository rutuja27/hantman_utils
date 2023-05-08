function[success] = readframe(void)

% parameters for extracting frame function
framechunksize = 100;
frontside = true;
ncell= 10;
ips = []; 
readframeFcns = [];
ts= [];
num_frames = 2;
usegpu = true;


%rutuja
dwnsample_factor=0.5;
dwnsample = false;
frame_mode = true;
patch_mode =false;
make_movie = false;
save = true;
rmpad = false;
tpatches=0;
bpatches=0;
lpatches=0;
rpatches=0;

% parameters for HOG/HOF 
wsize = 5;
psize = 40;
nbins = 8;
halfpsize = round(psize*ncell/2);
hsz = round( (wsize - 1)/2);

% rootdir - path to the video file
save_dir = '/groups/branson/home/patilr/rutuja_heffalump/rutuja_test/rutuja_profile/data/';
rootdir = '/groups/branson/home/patilr/hantman_data/exp_data/forRutuja/M173_20150423_v001';%hantman_data/cuda_hoghof/forRutuja/M173_20150423_v033';
if ~frontside && exist(fullfile(rootdir,'movie.avi'),'file') || ...
    frontside && isFrontSideExpDir(rootdir)
     
    curf  = rootdir;
    if frontside
        
      vidfile.front = fullfile(curf,'movie_frt.avi');
      vidfile.side = fullfile(curf,'movie_sde.avi');
      inputvidsexist = exist(vidfile.front,'file') && exist(vidfile.side,'file');

    else
      vidfile = fullfile(curf,'movie_sde.avi');            
      inputvidsexist = exist(vidfile,'file');
    end
    
    trxfile = fullfile(curf,'trx.mat');
    T = load(trxfile);
    face = T.trx(1).arena.face;
end

if isempty(face)
    error('Face direction of the mice is not specified');
end

if strcmpi(face,'left')
    do_fliplr = true;
else
    do_fliplr = false;
end

% get readframefcn 
tfvidfile = false;
if isempty(readframeFcns)
    if frontside
      assert(isstruct(vidfile) && all(isfield(vidfile,{'front' 'side'})),...
      'vidfile must be a struct with fields .front, .side.');
      [readFrameFcns.front.readframe,readFrameFcns.front.nframes,readFrameFcns.front.fid,readFrameFcns.front.headerinfo] = get_readframe_fcn(vidfile.front);
      [readFrameFcns.side.readframe,readFrameFcns.side.nframes,readFrameFcns.side.fid,readFrameFcns.side.headerinfo] = get_readframe_fcn(vidfile.side);       
    else
      [readFrameFcns.side.readframe,readFrameFcns.side.nframes,readFrameFcns.side.fid,readFrameFcns.side.headerinfo] = get_readframe_fcn(vidfile);
    end
      tfvidfile = true;
else
    if ~frontside
      readFrameFcns.side = readframeFcns;
    end
end

% get nframes
if frontside
  if readFrameFcns.front.nframes~=readFrameFcns.side.nframes
    warning('genFeatures:nframe',...
      'Number of frames in front video (%d) and side video (%d) do not match. Using minimum.',...
      readFrameFcns.front.nframes,readFrameFcns.side.nframes);
  end
  nframes = min(readFrameFcns.front.nframes,readFrameFcns.side.nframes);  
  % turns out we should cut from the end
  %offfront = readFrameFcns.front.nframes-nframes;
  %offside = readFrameFcns.side.nframes-nframes;
else
  nframes = readFrameFcns.side.nframes;
end

% make movie
if make_movie
  mv_name = strcat(rootdir,'/crop',int2str(psize),'_cell',int2str(ncell),'_movie.avi');
  crop_movie = VideoWriter(mv_name);
  crop_movie.FrameRate = readFrameFcns.side.headerinfo.FrameRate; 
  crop_movie.open();
end

%get ips - interest feature points
if ~isempty(ips) && ~isempty(trxfile)
    error('Both ips and trxfile specified.');  
elseif ~isempty(ips) && isempty(trxfile)
    if frontside
      assert(all(isfield(ips,{'front' 'side'})),'Expected fields missing from ips.');
    elseif ~isstruct(ips)
      ips = struct('side',ips);
    end
elseif isempty(ips) && ~isempty(trxfile)
    T = load(trxfile);
    h = readFrameFcns.side.headerinfo.Height;
    w = readFrameFcns.side.headerinfo.Width;
    ips.side(1,:) = T.trx(1).arena.food;
    ips.side(2,:) = T.trx(1).arena.mouth;
    ips.side(3,:) = T.trx(1).arena.perch;
    ips.side = round(ips.side);
    if frontside
      ips.front(1,:) = T.trx(1).arena.foodfront;
      ips.front(2,:) = T.trx(1).arena.mouthfront;
      ips.front = round(ips.front);     
    end
    %ips = shiftcrop(w,h,ips,frontside,halfpsize);   
    if rmpad
      [tpatches,bpatches,lpatches,rpatches] = padpatch(tpatches,bpatches,lpatches,rpatches,ips,frontside,halfpsize,w,h);
    end
    assert(strcmp(face,T.trx(1).arena.face),'Specified ''face'' does not match ''face'' in specified trxfile');
else
  % isempty(ips) && isempty(trxfile)
  % no-op; handled below
end

% if dwnsample
%   if frontside
%     ips_dwnsample.side = ceil(ips.side/2);
%     ips_dwnsample.front = ceil(ips.front/2);
%     struct2csv(ips_dwnsample,strcat(save_dir,'in_data/interest_points/M259_20180412_v001_dwnips.csv'));
%   else
%     ips_dwnsample.side = ceil(ips.side/2);
%     struct2csv(ips_dwnsample,strcat(save_dir,'in_data/interest_points/M259_20180412_v001_dwnips.csv'));
%   end
% else
%     struct2csv(ips,strcat(save_dir,'in_data/interest_points/M173_20150423_v001.csv'));
% end

if do_fliplr
  imw = readframeFcns.side.headerinfo.Width;
  ips.side(:,1) = imw - ips.side(:,1);  
  if frontside
    imw = readframeFcns.front.headerinfo.Width;
    ips.front(:,1) = imw - ips.front(:,1);    
  end
end

if isempty(ips),
  assert(~frontside,'Frontside currently requires interest point specification');
  patchsz = [readFrameFcns.side.headerinfo.Height,readFrameFcns.side.headerinfo.Width];
else 
  if frame_mode
    if dwnsample
        if frontside
          patchsz = [ceil(readFrameFcns.side.headerinfo.Height*dwnsample_factor),ceil(readFrameFcns.side.headerinfo.Width*dwnsample_factor)*2];    
        else    
           patchsz = [ceil(readFrameFcns.side.headerinfo.Height*dwnsample_factor),ceil(readFrameFcns.side.headerinfo.Width*dwnsample_factor)];
        end
    else  
      if frontside  
        patchsz = [readFrameFcns.side.headerinfo.Height,readFrameFcns.side.headerinfo.Width*2];
      else
        patchsz = [readFrameFcns.side.headerinfo.Height,readFrameFcns.side.headerinfo.Width];  
      end
    end  
  else   
      
    if patch_mode
      Npatch=1;
    else
      %Npatch=1;  
      Npatch = size(ips.side,1);  
      if frontside
        Npatch = Npatch + size(ips.front,1);
      end
    end
    
    if rmpad
      patchsz1 = tpatches+bpatches+1;
      patchsz2 = lpatches+rpatches+1;
    else
      patchsz1 = halfpsize*2+1;
    end  
    
    if dwnsample
      patchsz1 = ceil(patchsz1*dwnsample_factor);
    end
    
    if rmpad
      patchsz = [patchsz1,patchsz2]; 
    else
      patchsz = [patchsz1,patchsz1*Npatch];
    end      
  end
end

% modify patch size for gpu
if usegpu
    % hack to make sure width is divisible by sizeof(float)-required by gpu
    if ~(mod(patchsz(1),4) == 0)
        sz(1) = patchsz(1) + (4-mod(patchsz(1),4));
        sz(2) = patchsz(2);
    else
        sz = patchsz;
    end    
end

% timesteps
if isempty(ts)
  ts = 1:nframes;
  if any(diff(ts)~=1),
    error('ts must be starframe:endframe');
  end   
end


% previous and current patch
patchPrev = zeros(patchsz,'single');
patchCurr = zeros(patchsz,'single');

% which frames to read
ts2readstart = max(ts(1)-hsz,1);
ts2readend = min(ts(end)+hsz,nframes);
first = true;
% extract patch from videos 
for ndx = 1:num_frames%numel(ts),

  t = ts(ndx);

  % window considered during this frame
  wstart = max(1,t-hsz);
  wend = min(nframes,t+hsz);
  curn = wend - wstart +1;  
  
  if first,
       
    for wndx = 1:curn,
      patchPrev = patchCurr;
      if patch_mode 
        count=0;
        if frontside
          for i=1:size(ips.front,1) 
            patchCurr = lclGrabSinglePatch(readFrameFcns,wstart+wndx-1,do_fliplr,tfvidfile,1,halfpsize,patchCurr,ips,i);
            curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
            count = count+1;
            dlmwrite(strcat(save_dir,'in_data/patch_data/mseq_patch',int2str(psize),'_cell',int2str(ncell),'/mouse_patch_',string(wndx),'_patchfront_',string(count),'.csv'),(curpatch));
          end
          for i=1:size(ips.side,1)
             patchCurr = lclGrabSinglePatch(readFrameFcns,wstart+wndx-1,do_fliplr,tfvidfile,0,halfpsize,patchCurr,ips,i);
             curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
             count = count+1;
             dlmwrite(strcat(save_dir,'in_data/patch_data/mseq_patch',int2str(psize),'_cell',int2str(ncell),'/mouse_patch_',string(wndx),'_patchside_',string(count),'.csv'),(curpatch));
          end
        else
          for i=1:size(ips.side,1)
            patchCurr = lclGrabSinglePatch(readFrameFcns,wstart+wndx-1,do_fliplr,tfvidfile,0,halfpsize,patchCurr,ips,i);
            curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
            count = count+1;
            dlmwrite(strcat(save_dir,'in_data/patch_data/mseq_patch',int2str(psize),'_cell',int2str(ncell),'/mouse_patch_',string(wndx),'_patchside_',string(count),'.csv'),(curpatch));
          end            
        end
      else
        assert(frontside);
        if ~rmpad
          patchCurr = lclGrabPatch(readFrameFcns,wstart+wndx-1,do_fliplr,tfvidfile,frontside,ips,halfpsize,patchCurr,dwnsample,dwnsample_factor,frame_mode);
          curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
        else
          patchCurr = lclGrabPatch(readFrameFcns,wstart+wndx-1,do_fliplr,tfvidfile,frontside,ips,tpatches,bpatches,lpatches,rpatches,patchCurr,dwnsample,dwnsample_factor);
          curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
        end    
        if save
           dlmwrite(strcat(save_dir,'in_data/frame_data/mseq_patch',int2str(psize),'_cell',int2str(ncell),'/mouse_patch_',string(wndx),'.csv'),(curpatch));
        end
        if make_movie
           crop_movie.writeVideo(curpatch/255); 
        end
      end
    end
    
  else
      
      patchPrev = patchCurr;
      if patch_mode 
        count=0;
        if frontside
          for i=1:size(ips.front,1) 
            patchCurr = lclGrabSinglePatch(readFrameFcns,wend,do_fliplr,tfvidfile,1,halfpsize,patchCurr,ips,i);
            curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
            count = count+1;
            dlmwrite(strcat(save_dir,'in_data/patch_data/mseq_patch',int2str(psize),'_cell',int2str(ncell),'/mouse_patch_',string(wend),'_patchfront_',string(count),'.csv'),(curpatch));
          end
          for i=1:size(ips.side,1)
             patchCurr = lclGrabSinglePatch(readFrameFcns,wend,do_fliplr,tfvidfile,0,halfpsize,patchCurr,ips,i);
             curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
             count = count+1;
             dlmwrite(strcat(save_dir,'in_data/patch_data/mseq_patch',int2str(psize),'_cell',int2str(ncell),'/mouse_patch_',string(wend),'_patchside_',string(count),'.csv'),(curpatch));
          end
        else
          for i=1:size(ips.side,1)
            patchCurr = lclGrabSinglePatch(readFrameFcns,wend,do_fliplr,tfvidfile,0,halfpsize,patchCurr,ips,i);
            curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
            count = count+1;
            dlmwrite(strcat(save_dir,'in_data/patch_data/mseq_patch',int2str(psize),'_cell',int2str(ncell),'/mouse_patch_',string(wend),'_patchside_',string(count),'.csv'),(curpatch));
          end            
        end
      else
        assert(frontside);
        if ~rmpad
          patchCurr = lclGrabPatch(readFrameFcns,wend,do_fliplr,tfvidfile,frontside,ips,halfpsize,patchCurr,dwnsample,dwnsample_factor,frame_mode);
          curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));  
        else
          patchCurr = lclGrabPatch(readFrameFcns,wstart+wndx-1,do_fliplr,tfvidfile,frontside,ips,tpatches,bpatches,lpatches,rpatches,patchCurr,dwnsample,dwnsample_factor);
          curpatch = cat(1,patchCurr,zeros(sz(1)-patchsz(1),sz(2)));
        end  
        if save
         dlmwrite(strcat(save_dir,'in_data/frame_data/mseq_patch',int2str(psize),'_cell',int2str(ncell),'/mouse_patch_',string(wend),'.csv'),(curpatch));
        end 
        if make_movie
           crop_movie.writeVideo(curpatch/255); 
        end
      end
      
  end 
  first = false;  
end
if make_movie
    crop_movie.close();
end
success=true;


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


function patchMat = lclGrabPatch(readFrameFcns,f,do_fliplr,tfvidfile,frontside,ips,halfpsize,patchMat,downsample,downsample_factor,frame_mode)

imMat.side = lclReadFrame(readFrameFcns.side,f,f,do_fliplr,tfvidfile);
if frontside
  imMat.front = lclReadFrame(readFrameFcns.front,f,f,do_fliplr,tfvidfile);
end

if downsample 
  imMat.side = imresize(imMat.side,downsample_factor);
  if frontside
    imMat.front = imresize(imMat.front,downsample_factor);
  end
end

patchsz1 = size(patchMat,1);
if ~isempty(ips) && ~frame_mode
  Nipsside = size(ips.side,1); 
  for pndx = 1:Nipsside
    if downsample
      pp = padgrab(imMat.side,0,...
        ceil((ips.side(pndx,2)-halfpsize)*downsample_factor),ceil((ips.side(pndx,2)+halfpsize)*downsample_factor),...
        ceil((ips.side(pndx,1)-halfpsize)*downsample_factor),ceil((ips.side(pndx,1)+halfpsize)*downsample_factor),...
        1,size(imMat.side,3));  
    else    
      pp = padgrab(imMat.side,0,...
        ips.side(pndx,2)-halfpsize,ips.side(pndx,2)+halfpsize,...
        ips.side(pndx,1)-halfpsize,ips.side(pndx,1)+halfpsize,...
        1,size(imMat.side,3));
    end
    patchMat(:,(pndx-1)*patchsz1+1:pndx*patchsz1) = pp;
  end
  if frontside
    for pndx = 1:size(ips.front,1)
      if downsample
        pp = padgrab(imMat.front,0,...
          ceil((ips.front(pndx,2)-halfpsize)*downsample_factor),ceil((ips.front(pndx,2)+halfpsize)*downsample_factor),...
          ceil((ips.front(pndx,1)-halfpsize)*downsample_factor),ceil((ips.front(pndx,1)+halfpsize)*downsample_factor),...
          1,size(imMat.front,3));  
      else    
        pp = padgrab(imMat.front,0,...
          ips.front(pndx,2)-halfpsize,ips.front(pndx,2)+halfpsize,...
          ips.front(pndx,1)-halfpsize,ips.front(pndx,1)+halfpsize,...
          1,size(imMat.front,3));
      end
      patchMat(:,(pndx-1+Nipsside)*patchsz1+1:(pndx+Nipsside)*patchsz1) = pp;
    end
  end
elseif (frame_mode && ~isempty(ips))
  if frontside       
    patchMat(:,1:size(patchMat,2)/2) = imMat.side;       
    patchMat(:,size(patchMat,2)/2+1:end) = imMat.front;
  else             
    patchMat(:,1:size(patchMat,2)) = imMat.side;     
  end
else
  assert(~frontside);
  patchMat = imMat.side;
end





% function patchMat = lclGrabSinglePatch(readFrameFcns,f,do_fliplr,tfvidfile,frontside,halfpsize,patchMat,ips,ips_idx)
% 
% if frontside
%   imMat.front = lclReadFrame(readFrameFcns.front,f,f,do_fliplr,tfvidfile);
% else
%   imMat.side = lclReadFrame(readFrameFcns.side,f,f,do_fliplr,tfvidfile);  
% end
% 
% patchsz1 = size(patchMat,1);
% if frontside
%   pp = padgrab(imMat.front,0,...
%           ips.front(ips_idx,2)-halfpsize,ips.front(ips_idx,2)+halfpsize,...
%           ips.front(ips_idx,1)-halfpsize,ips.front(ips_idx,1)+halfpsize,...
%           1,size(imMat.front,3));    
% else
%   pp = padgrab(imMat.side,0,...
%         ips.side(ips_idx,2)-halfpsize,ips.side(ips_idx,2)+halfpsize,...
%         ips.side(ips_idx,1)-halfpsize,ips.side(ips_idx,1)+halfpsize,...
%         1,size(imMat.side,3));  
% end    
% patchMat=pp;
% end

