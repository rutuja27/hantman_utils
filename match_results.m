

h=260;
w=352;
cu = csvread('/groups/branson/home/patilr/hantman_data/test/hof_driver_cuda/frame/outputHOF_dx_side_1.csv');
mat = load('/groups/branson/home/patilr/hantman_data/test/hof_driver_matlab/Vx_1.mat');

mat = reshape(mat.Vx, [1 w*h]);
cu = reshape(cu, [w h]);
cu = permute(cu, [2 1]);
cu = reshape(cu, [1 w*h]);

d = max(diff(abs(mat-cu)));
fprintf('The max difference in cuda-mat is %f',d);

plot(mat,cu,'.');
xlabel('Matlab')
ylabel('Cuda')
