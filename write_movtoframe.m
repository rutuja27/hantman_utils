
mov_file_dir = 'Y:\hantman_data\jab_experiments\M274Vglue2_Gtacr2_TH\20180814\M274_20180814_v002/';
mov_name = 'movie_sde.avi';
output_dir = 'Z:\patilr\hantman_data\test_output_LK\frames\';
output_file_name = 'frame_';

%% read movie and save to csv
vidObj = VideoReader(strcat(mov_file_dir,mov_name));
frm_id = 1;
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
    frm = im2gray(vidFrame);
    fname = strcat(output_dir,output_file_name) + sprintf("%04d", frm_id) + ".csv";
    frm_id = frm_id + 1;
    disp(fname);
    writematrix(frm,fname);
end