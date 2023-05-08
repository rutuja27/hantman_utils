psize = 40;
ncells = 10;
nbins = 8;
w = 352;
h = 260;
num_frame=1;

npatches_side = 3;
npatches_front=2;
npatches=npatches_side+npatches_front;


side_dim = ((ncells*psize/psize)*((ncells*psize*npatches_side)/psize)*nbins);
front_dim = ((ncells*psize/psize)*((ncells*psize*npatches_front)/psize)*nbins);
hog_dim = ((ncells*psize/psize)*((ncells*psize*npatches)/psize)*nbins);
hof_dim = ((ncells*psize/psize)*((ncells*psize*npatches)/psize)*nbins);

side_hist_shape = [((ncells*psize*npatches_side)/psize) (ncells*psize/psize) nbins];
front_hist_shape = [((ncells*psize*npatches_front)/psize) (ncells*psize/psize) nbins];

%% reshaping matlab results
flow_sidem = load('Y:/patilr/hantman_data/matlab_hoghof/forRutuja/M173_20150423_v001/flowfeatures_side.mat');
hog_sidem = load('Y:/patilr/hantman_data/matlab_hoghof/forRutuja/M173_20150423_v001/hogfeatures_side.mat');
flow_frontm = load('Y:/patilr/hantman_data/matlab_hoghof/forRutuja/M173_20150423_v001/flowfeatures_front.mat');
hog_frontm = load('Y:/patilr/hantman_data/matlab_hoghof/forRutuja/M173_20150423_v001/hogfeatures_front.mat');

flow_sidem = flow_sidem.F(:,:,:,num_frame);
hog_sidem = hog_sidem.H(:,:,:,num_frame);
flow_frontm = flow_frontm.F(:,:,:,num_frame);
hog_frontm = hog_frontm.H(:,:,:,num_frame);

Fm = [flow_sidem flow_frontm];
Hm = [hog_sidem hog_frontm];

Fm = reshape(Fm,[1 hof_dim]);
Hm = reshape(Hm,[1 hog_dim]);

%% reshaping cuda results
flow_sidec = hdf5read('Y:/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423_v001/M173_20150423_v001','hof_side');
hog_sidec = hdf5read('Y:/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423_v001/M173_20150423_v001','hog_side');
flow_frontc = hdf5read('Y:/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423_v001/M173_20150423_v001','hof_front');
hog_frontc = hdf5read('Y:/patilr/hantman_data/cuda_hoghof_v4/forRutuja/M173_20150423_v001/M173_20150423_v001','hog_front');

%transpose the bins
flow_sidec = flow_sidec(:,num_frame+1);
flow_sidec = reshape(flow_sidec,side_hist_shape);
flow_sidec = permute(flow_sidec,[2 1 3]);

hog_sidec = hog_sidec(:,num_frame);
hog_sidec =  reshape(hog_sidec,side_hist_shape);
hog_sidec = permute(hog_sidec,[2 1 3]);

flow_frontc = flow_frontc(:,num_frame+1);
flow_frontc = reshape(flow_frontc,front_hist_shape);
flow_frontc = permute(flow_frontc,[2 1 3]);

hog_frontc = hog_frontc(:,num_frame);
hog_frontc = reshape(hog_frontc,front_hist_shape);
hog_frontc = permute(hog_frontc,[2 1 3]);

Fc = [flow_sidec flow_frontc];
Hc = [hog_sidec hog_frontc];

Fc = reshape(Fc,[1 hof_dim]);
Hc = reshape(Hc,[1 hog_dim]);

figure
subplot(2,2,1)
plot(Hm,Hc,'.')
title('HOG')
xlabel('MATLAB')
ylabel('CUDA')
subplot(2,2,2)
plot(Fm,Fc,'.')
xlabel('MATLAB')
ylabel('CUDA')
title('HOF')