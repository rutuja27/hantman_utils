addpath /groups/branson/home/patilr/JAABA/spaceTime/toolbox/channels/
addpath('/groups/branson/home/patilr/JAABA/spaceTime/adamMice/pdollarOF/')
addpath('/groups/branson/home/patilr/hantman_data/utils')
%addpath Z:\patilr\JAABA\spaceTime\pdollarOF\
%% directory information

input_dir = '/groups/branson/home/patilr/hantman_data/test_output_LK/frames/';
input_fname = 'frame_';
output_dir = '/groups/branson/home/patilr/hantman_data/test_output_gradHist_cuda/';
output_fname_cuda = 'hist_out.csv';
numFrames = 2498;
cellw = 4;cellh=4;
nbins=8;

%% read data
for i=1:1
        
    im1 = readmatrix(strcat(input_dir,input_fname) + sprintf("%04d",i) + ".csv");
    [x,y] = size(im1);
    %permute data

    im1 = ones(x,y);
    im2 = ones(x,y);
    im1(1:x/2,1:y/2)=0;
    im1 = permute(im1 ,[2 1]);
    im1 = single(im1);

        
    % Lukas Kanad./op   eGx

    %[Vx,Vy,reliab] = optFlowLk(im1,im2,[],3);
    [m,o] = gradientMag(im1);
    histm = gradientHist(single(m),single(o),[cellw, cellh],nbins,1);
    %histm = permute(histm, [2 1 3]);
    histm = reshape(histm, [1, 96*65*8]);
end

histc = readmatrix(strcat(output_dir,output_fname_cuda));
plot(histm,histc,'.');
