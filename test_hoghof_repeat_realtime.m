function test_hoghof_repeat_realtime(indir,file_suffix1, file_suffix2)

%file_dir = 'Y:\hantman_data\jab_experiments\STA14\STA14\20230503\STA14_20230503_142341\'; 
hoghof_side1 = readtable(indir + "hoghof_avg_side_biasjaaba" + file_suffix1 + ".csv");
hoghof_side2 = readtable(indir + "hoghof_avg_side_biasjaaba" + file_suffix2 + ".csv");

hoghof_front1 = readtable(indir + "hoghof_avg_front_biasjaaba" + file_suffix1 + ".csv");
hoghof_front2 = readtable(indir + "hoghof_avg_front_biasjaaba" + file_suffix2 + ".csv");

feat_size_side = size(hoghof_side1,2);
feat_size_front = size(hoghof_front1,2);
numframes = size(hoghof_front1,1);

%frame that differs the most
side_diff = hoghof_side1{:,:} - hoghof_side2{:,:};
front_diff = hoghof_front1{:,:} - hoghof_front2{:,:};
nnz_side_frames = zeros(1,size(hoghof_side1,1));
nnz_front_frames = zeros(1,size(hoghof_front1,1));
for i=1:numframes
   nnz_side_frames(i) = nnz(side_diff(i,:));
   nnz_front_frames(i) = nnz(front_diff(i,:));
end

hogs1 = hoghof_side1{:,1:feat_size_side/2};
hogs2 = hoghof_side2{:,1:feat_size_side/2};
hogf1 = hoghof_front1{:,1:feat_size_front/2};
hogf2 = hoghof_front2{:,1:feat_size_front/2};

hofs1 = hoghof_side1{:,(feat_size_side/2)+1:feat_size_side};
hofs2 = hoghof_side2{:,(feat_size_side/2)+1:feat_size_side};
hoff1 = hoghof_front1{:,(feat_size_front/2)+1:feat_size_front};
hoff2 = hoghof_front2{:,(feat_size_front/2)+1:feat_size_front}; 


side_diff_hog = hogs1 - hogs2; 
[min_side_diff_hog, max_side_diff_hog] = getMinMax(side_diff_hog);
[v,id] = mink(min_side_diff_hog, 20);
fprintf("%d, " ,id);
fprintf("%.7f, ",v);
[min_hogs_val , min_hogs_frm] = min(min_side_diff_hog);
[max_hogs_val , max_hogs_frm] = max(max_side_diff_hog);
fprintf("Min HOG side %.7f - %d\n", min_hogs_val, min_hogs_frm)
fprintf("Max HOG side %.7f - %d\n", max_hogs_val, max_hogs_frm)
subplot(4,1,1)
imagesc(side_diff_hog',[min_hogs_val,max_hogs_val])
colorbar

%fprintf("Max  Min HOG %.7f- %.7f\n", max_side_diff_hog,min_side_diff_hog)
%assert(min_side_diff==max_side_diff)

side_diff_hof = hofs1 - hofs2;
[min_side_diff_hof, max_side_diff_hof] = getMinMax(side_diff_hof);
[min_hofs_val, min_hofs_frm] = min(min_side_diff_hof);
[max_hofs_val, max_hofs_frm] = max(max_side_diff_hof);
fprintf("Min HOF Side %.7f - %d\n", min_hofs_val, min_hofs_frm)
fprintf("Max HOF Side %.7f - %d\n", max_hofs_val, max_hofs_frm)
subplot(4,1,2)
imagesc(side_diff_hof',[min_hofs_val,max_hofs_val])
colorbar
%assert(min_front_diff==max_front_diff)

front_diff_hog = hogf1 - hogf2;
[min_front_diff_hog, max_front_diff_hog] = getMinMax(front_diff_hog);
[min_hogf_val, min_hogf_frm] = min(min_front_diff_hog);
[max_hogf_val, max_hogf_frm]= max(max_front_diff_hog);
fprintf("Min HOG Front %.7f - %d\n", min_hogf_val, min_hogf_frm)
fprintf("Max HOG Front %.7f - %d\n", max_hogf_val, max_hogf_frm)
subplot(4,1,3)
imagesc(front_diff_hog', [min_hogf_val, max_hogf_val])
colorbar
%fprintf("Max Min HOG %.7f\n", max_front_diff_hof,min_front_diff_hog)

front_diff_hof = hoff1 - hoff2; 
[min_front_diff_hof, max_front_diff_hof] = getMinMax(front_diff_hof);
[min_hoff_val, min_hoff_frm] = min(min_front_diff_hof);
[max_hoff_val, max_hoff_frm] = max(max_front_diff_hof);
fprintf("Min HOG Front %.7f - %d\n", min_hoff_val, min_hoff_frm)
fprintf("Max HOG Front %.7f - %d\n", max_hoff_val, max_hoff_frm)
subplot(4,1,4)
imagesc(front_diff_hof', [min_hoff_val, max_hoff_val])
colorbar
%fprintf("Max Min HOF %.7f\n", max_front_diff_hof,min_front_diff_hof)

figure(2)
subplot(2,1,1)
plot(hoghof_front2{:,:},hoghof_front1{:,:},'.')
subplot(2,1,2)
plot(hoghof_side2{:,:},hoghof_side1{:,:},'.')