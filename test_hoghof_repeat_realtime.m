file_dir = 'Y:\hantman_data\jab_experiments\STA14\STA14\20230503\STA14_20230503_142341\'; 
hoghof_side1 = readtable(file_dir + "hoghof_side_biasjaaba.csv");
hoghof_side2 = readtable(file_dir + "hoghof_side_biasjaaba_test.csv");

hoghof_front1 = readtable(file_dir + "hoghof_front_biasjaaba.csv");
hoghof_front2 = readtable(file_dir + "hoghof_front_biasjaaba_test.csv");

subplot(2,1,1)
plot(hoghof_front2{:,:},hoghof_front1{:,:},'.')
subplot(2,1,2)
plot(hoghof_side2{:,:},hoghof_side1{:,:},'.')