psize = 40;
ncells = 10;
nbins = 8;
w = 352;
h = 260;

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
flow_sidem = load('~/hantman_data/exp_data/forRutuja/M173_20150423_v001/flowfeatures_side.mat');
hog_sidem = load('~/hantman_data/exp_data/forRutuja/M173_20150423_v001/hogfeatures_side.mat');
flow_frontm = load('~/hantman_data/exp_data/forRutuja/M173_20150423_v001/flowfeatures_front.mat');
hog_frontm = load('~/hantman_data/exp_data/forRutuja/M173_20150423_v001/hogfeatures_front.mat');

flow_sidem = flow_sidem.F(:,:,:,3);
hog_sidem = hog_sidem.H(:,:,:,3);
flow_frontm = flow_frontm.F(:,:,:,3);
hog_frontm = hog_frontm.H(:,:,:,3);

Fm = [flow_sidem flow_frontm];
Hm = [hog_sidem hog_frontm];

Fm = reshape(Fm,[1 hof_dim]);
Hm = reshape(Hm,[1 hog_dim]);


%% reshaping cuda results
flow_sidec = load('~/hantman_data/test/outputHOF_00003_side.csv');
hog_sidec = load('~/hantman_data/test/outputHOG_00003_side.csv');
flow_frontc = load('~/hantman_data/test/outputHOF_00003_front.csv');
hog_frontc = load('~/hantman_data/test/outputHOG_00003_front.csv');

%transpose the bins
flow_sidec = reshape(flow_sidec,side_hist_shape);
flow_sidec = permute(flow_sidec,[2 1 3]);

hog_sidec =  reshape(hog_sidec,side_hist_shape);
hog_sidec = permute(hog_sidec,[2 1 3]);

flow_frontc = reshape(flow_frontc,front_hist_shape);
flow_frontc = permute(flow_frontc,[2 1 3]);

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
subplot(2,2,2)
plot(Fm,Fc,'.')
title('HOF')


