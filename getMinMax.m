function [min_val, max_val] = getMinMax(input_arr)

   min_val = min(input_arr,[], 2);
   max_val = max(input_arr,[], 2);
   