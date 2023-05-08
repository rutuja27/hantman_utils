%% addpath
addpath('/groups/branson/home/patilr/JAABA/spaceTime/adamMice/pdollarOF/')
addpath('/groups/branson/home/patilr/hantman_data/utils')
%% directory information

input_dir = '/groups/branson/home/patilr/hantman_data/test_output_LK/frames/';
input_fname = 'frame_';
output_dir = '/groups/branson/home/patilr/hantman_data/test_output_LK/output_HOF_matlab/';
output_fname1 = 'output_x_';
output_fname2 = 'output_y_';
numFrames = 2498;

%% read data
for i=1:2
    if(i == 1)
        im2 = readmatrix(strcat(input_dir,input_fname) + sprintf("%04d",i) + ".csv");
        im1=im2;
    else
        im1 = readmatrix(strcat(input_dir,input_fname) + sprintf("%04d",i-1) + ".csv");
        im2 = readmatrix(strcat(input_dir,input_fname) + sprintf("%04d",i) + ".csv");
    end
    
    [x,y] = size(im1);
    %permute data
    im1 = permute(im1 ,[2 1]);
    im2 = permute(im2 ,[2 1]);
    im1 = double(im1)/255;
    im2 = double(im2)/255;
        
    % Lukas Kanad./op   eGx

    [Gx,Gy,reliab] = optFlowLk(im1,im2,[],3,1);
    f1 = strcat(output_dir,output_fname1) + sprintf("%04d", i) + ".csv";
    f2 = strcat(output_dir,output_fname2) + sprintf("%04d", i) + ".csv";
    writematrix(Gx,f1);
    writematrix(Gy,f2);
end

vx_m = readmatrix('/groups/branson/home/patilr/hantman_data/test_output_LK/output_HOF_matlab/output_y_0002.csv');
vx_c = readmatrix('/groups/branson/home/patilr/hantman_data/test_output_LK/output_HOF_cuda/outputHOF_x_0002.csv');
vx_m = reshape(vx_m,[1, x*y]);
reliab = reshape(reliab, [1, x*y]);
plot(vx_m,vx_c,'.');
xlabel('Matlab')
ylabel('Cuda')