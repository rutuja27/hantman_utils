function plot_featvariability(exp_dir, varargin)
 
   %[] = myparse(varargin, '');
%%
   feat = load(exp_dir + "/features_1.mat");
   feat = feat.curFeatures;
   sz = size(feat);
   nRuns = 5;
%%
   features = zeros(sz(1), sz(2), nRuns, 'double');
   
   for run_id=1:nRuns
       featstrct = load(exp_dir + "/features_" + int2str(run_id) + '.mat');
       features(:,:,run_id) = featstrct.curFeatures;
       disp(size(features(:,:,nRuns)))
   end
%%
   stdfeat = std(features,0,3);
   disp(size(stdfeat));

%% plot feature variability
  ax = gca;
  clims = [min(min(stdfeat)), max(max(stdfeat))];
  imagesc(stdfeat',clims);
  colorbar ;
  ylabel('Feature id');
  xlabel('Frames');
  title('Standard deviation of features along 5 runs across frames','Fontsize',25);
  set(gcf,'position',[500,500,2000,1000]);
  ax.FontSize = 20;
  saveas(gcf,exp_dir + "/feature_variability_in_runs_plottedacrossframes.jpg")
  
 

