%% addpath
addpath('/groups/branson/home/patilr/JAABA/spaceTime/adamMice/pdollarOF/')
%% directory information

input_dir = '/groups/branson/home/patilr/hantman_data/test_output_LK/frames/';
input_fname = 'frame_';
output_dir_cuda = '/groups/branson/home/patilr/hantman_data/test_output_LK/output_HOF_cuda/';
output_fname1 = 'outputHOF_x_';
output_fname2 = 'outputHOF_y_';
numFrames = 2498;
%% read HOF results for cuda
i=3;
Vx_optLk_cuda = readmatrix(strcat(output_dir_cuda,output_fname1) + sprintf("%04d",i) + ".csv");
Vy_optLk_cuda = readmatrix(strcat(output_dir_cuda,output_fname2) + sprintf("%04d",i) + ".csv");

%% read HOF results for matlab
i=2;
if(i == 1)
    im2 = readmatrix(strcat(input_dir,input_fname) + sprintf("%04d",i) + ".csv");
    im1=im2;
else
    im1 = readmatrix(strcat(input_dir,input_fname) + sprintf("%04d",i-1) + ".csv");
    im2 = readmatrix(strcat(input_dir,input_fname) + sprintf("%04d",i) + ".csv");
end

[x,y] = size(im1);
%permute data to match c style ordering
im1 = permute(im1 ,[2 1]);
im2 = permute(im2 ,[2 1]);
im1 = double(im1)/255;
im2 = double(im2)/255;

sigma=3;  
sz = size(im1);
w=sz(1);
h=sz(2);

im_gausfilt = imgaussfilt(im1,sigma,padding=0);
im_gauSmooth = gaussSmooth(im1,sigma,'same',2);

im_gausfilt = reshape(im_gausfilt, [1 (w*h)]);
im_gauSmooth = reshape(im_gauSmooth, [1 (w*h)]);

%plot(im_gausfilt,im_gauSmooth,'.');

Vx_optLk_gauss, Vy_optLK_gauss = optFlowLk(im1,im2,[],sigma);
Vx_optLk_filt, Vy_optLK_filt  = myoptFlowLK(im1,im2,[],sigma);

Vx_optLk_filt = reshape(Vx_optLk_filt, [1 (w*h)]);
Vx_optLk_gauss = reshape(Vx_optLk_gauss, [1 (w*h)]);
Vy_optLk_filt = reshape(Vy_optLk_filt, [1 (w*h)]);
Vy_optLk_gauss = reshape(Vy_optLk_gauss, [1 (w*h)]);

%plot(Vy_optLk_gauss, Vy_optLk_filt,'.')

plot(Vx_optLk_cuda, Vx_optLk_gauss)