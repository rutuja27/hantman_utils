addpath /groups/branson/home/patilr/JAABA/spaceTime/toolbox/channels
addpath /groups/branson/home/patilr/JAABA/spaceTime/adamMice/pdollarOF
addpath /groups/branson/home/patilr/JAABA/spaceTime/adamMice

local_jabfile = '/nrs/branson/jab_experiments/M277PSAMBpn/FinalJAB/M277_20181005_convert.jab';%%'/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423.jab';   
out_dir = '/nrs/branson/jab_experiments/';%%'/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/';                           
jd = loadAnonymous(local_jabfile);
filepaths = jd.expDirNames;
dwnsample = false;
ips = []; 

fileID = fopen(fullfile(out_dir,'hantman_list.txt'),'w');

for i=1:numel(filepaths)

%get video info
[vr,nframes,fid,headerinfo] = get_readframe_fcn(strcat(filepaths{i},'/movie_comb.avi'));
    
%load corresponding trx
trxfile = fullfile(filepaths{i},'trx.mat');
T = load(trxfile);
face = T.trx(1).arena.face;

%get ips - interest feature points
if ~isempty(ips) && ~isempty(trxfile)
    
    error('Both ips and trxfile specified.');  
    
elseif isempty(ips) && ~isempty(trxfile)
   
    T = load(trxfile);
    if dwnsample
        
        ips.side(1,:) = T.trx(1).arena.food/2;
        ips.side(2,:) = T.trx(1).arena.mouth/2;
        ips.side(3,:) = T.trx(1).arena.perch/2;
        ips.side = round(ips.side);
       
        ips.front(1,:) = T.trx(1).arena.foodfront/2;
        ips.front(2,:) = T.trx(1).arena.mouthfront/2;
        ips.front = round(ips.front);
        
    else
        
        ips.side(1,:) = T.trx(1).arena.food;
        ips.side(2,:) = T.trx(1).arena.mouth;
        ips.side(3,:) = T.trx(1).arena.perch;
        ips.side = round(ips.side);
       
        ips.front(1,:) = T.trx(1).arena.foodfront;
        ips.front(2,:) = T.trx(1).arena.mouthfront;
        ips.front = round(ips.front);
        
    end
    
    assert(strcmp(face,T.trx(1).arena.face),'Specified ''face'' does not match ''face'' in specified trxfile');
else
  % isempty(ips) && isempty(trxfile)
  % no-op; handled below
end

parts = strsplit(filepaths{i},'/');
fpath = extractBefore(filepaths{i},parts{end});
exp_name = parts{end};
fprintf(fileID,'%s,%s,%d\n',fpath, exp_name, nframes);
%struct2csv(ips,strcat(filepaths{i},'/',exp_name,'_ips.csv'));
if dwnsample
    
    dlmwrite(strcat(filepaths{i},'/cuda_dir',exp_name,'_ips_side_dwnsample.csv'),ips.side)
    dlmwrite(strcat(filepaths{i},'/cuda_dir',exp_name,'_ips_front_dwnsample.csv'),ips.front);
    
else
    
    dlmwrite(strcat(filepaths{i},'/cuda_dir/',exp_name,'_ips_side.csv'),ips.side)
    dlmwrite(strcat(filepaths{i},'/cuda_dir/',exp_name,'_ips_front.csv'),ips.front);
    
end 

ips=[];
            
end    

fclose(fileID);