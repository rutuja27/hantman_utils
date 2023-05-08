% reshape MATLAB features

psize =40;
nbins =8;
ncells=10;
npatches_side= 3;
npatches_front=2;
npatches=npatches_side+npatches_front;
compute_matlab = false;
compute_cuda = true;

if compute_matlab
  load_path = '~/hantman_data/matlab_40x5_v4/forRutuja/';
  local_jabfile = fullfile(load_path,'M173_20150423.jab');
  jd = loadAnonymous(local_jabfile);
  filepaths = jd.expDirNames;

  for i=1:numel(filepaths)
    
    exp_name = extractAfter(filepaths{i},'forRutuja/'); 
    if exist(fullfile(load_path,exp_name,'features.mat'),'file')
      fprintf("Features already generated for %s \n",exp_name);  
      continue; 
    else    
      flow_sidem = load(fullfile(load_path,exp_name,'flowfeatures_side.mat'));
      hog_sidem = load(fullfile(load_path,exp_name,'hogfeatures_side.mat'));
      flow_frontm = load(fullfile(load_path,exp_name,'flowfeatures_front.mat'));
      hog_frontm = load(fullfile(load_path,exp_name,'hogfeatures_front.mat'));

      flowm = [flow_sidem.F flow_frontm.F];
      hogm = [hog_sidem.H hog_frontm.H];

      sz_flow = size(flowm);
      sz_hog = size(hogm);
      assert(sz_flow(4)==sz_hog(4));
      nframes = sz_flow(4);

      flowm = reshape(flowm ,[] ,nframes)';
      hogm = reshape(hogm ,[] ,nframes)';

      curFeatures = [flowm hogm];
      save(fullfile(load_path,exp_name,'features.mat'),'curFeatures');
      fprintf("Finished generating features for experiment %s \n",exp_name);
    
    end
  end
end  
%% reshape cuda 

if compute_cuda
    load_path = '/nrs/branson/jab_experiments/';%%'/groups/branson/home/patilr/hantman_data/cuda_hoghof_v4/forRutuja/';
    local_jabfile = fullfile(load_path,'M277PSAMBpn/FinalJAB/cuda_jabs/M277_20181005_convert.jab'); %%'M173_20150423_convert.jab');
    jd = loadAnonymous(local_jabfile);
    filepaths = jd.expDirNames;
    
    hist_shape_front = [((ncells*psize*npatches_front)/psize) (ncells*psize/psize) nbins];
    hist_shape_side = [((ncells*psize*npatches_side)/psize) (ncells*psize/psize) nbins];
    

    for i=1:1%numel(filepaths)
            
        parts = strsplit(filepaths{i},'/');
        exp_name = parts{end-1};
        if exist(fullfile(filepaths{i},'/cuda_dir','features.mat'),'file')
            continue;
        else
            hog_sidec = hdf5read(fullfile(filepaths{i},exp_name),'hog_side');
            hog_frontc = hdf5read(fullfile(filepaths{i},exp_name),'hog_front');
            hof_sidec =  hdf5read(fullfile(filepaths{i},exp_name),'hof_side');
            hof_frontc = hdf5read(fullfile(filepaths{i},exp_name),'hof_front');
            
            sz_flow = size(hof_sidec);
            sz_hog = size(hog_sidec);
            assert(sz_flow(2)==sz_hog(2));
            nframes = sz_flow(2);
            
            hog_sidec = reshape(hog_sidec,[hist_shape_side nframes]);
            hog_sidec  = permute(hog_sidec,[2 1 3 4]);
            %hog_sidec = reshape(hog_sidec,[sz_hog(1) nframes]);
            
            hof_sidec = reshape(hof_sidec,[hist_shape_side nframes]);
            hof_sidec  = permute(hof_sidec,[2 1 3 4]);
            %hof_sidec = reshape(hof_sidec,[sz_flow(1) nframes]);
            
            
            hog_frontc = reshape(hog_frontc,[hist_shape_front, nframes]);
            hog_frontc  = permute(hog_frontc,[2 1 3 4]);
            %hog_frontc = reshape(hog_frontc,[sz_hog(1) nframes]);
            
            hof_frontc = reshape(hof_frontc,[hist_shape_front, nframes]);
            hof_frontc  = permute(hof_frontc,[2 1 3 4]);
            %hof_frontc = reshape(hof_frontc,[sz_flow(1) nframes]);
            
            hogc = [hog_sidec hog_frontc];
            flowc = [hof_sidec hof_frontc];
            
            flowc = reshape(flowc ,[] ,nframes)';
            sz  = size(flowc);
            flowc = [flowc(2:end,:);zeros(1,sz(2))];
            
            hogc = reshape(hogc ,[] ,nframes)';
            
            curFeatures = [flowc hogc];
            save(fullfile(filepaths{i},'/cuda_dir/features.mat'),'curFeatures');
            fprintf("Finished generating features for experiment %s \n",exp_name);
            
        end
    end
end    