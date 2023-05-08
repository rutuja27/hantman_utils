% local_jb1 = '/groups/branson/home/patilr/heffalump/rutuja_profile/data/out_data/op1_'; 
% local_jb2 = '/groups/branson/home/patilr/heffalump/rutuja_profile/data/out_data/op2_'; 
% dif = zeros(298,162004);
% %figure
% for i=1:298
%   jd1 = load(strcat(local_jb1,int2str(i),'.csv')); %%sprintf('%03d',i),'/features.mat')); 
%   jd2 = load(strcat(local_jb2,int2str(i),'.csv'));%%sprintf('%03d',i),'/features.mat')); 
%   dif(i,:) = jd1 - jd2;
% end
% score = sum(sum(dif));

local_jb1 = '/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423_v'; 
local_jb2 = '/groups/branson/home/patilr/hantman_data/cudawn/forRutuja/M173_20150423_v';
nexps=70;
for exps=1:nexps    
    
  jd1 = load(strcat(local_jb1,sprintf('%03d',exps),'/features.mat'));
  v = zeros(size(jd1.curFeatures));
  for j=1:size(jd1.curFeatures,1) 
    v(j,:) = (0.01*std(jd1.curFeatures(j,:))).*randn(size(jd1.curFeatures(j,:)));
  end  
  curFeatures = jd1.curFeatures + v;  
  save(strcat(local_jb2,sprintf('%03d',exps),'/features.mat'),'curFeatures');
  clear 'v';
  
end