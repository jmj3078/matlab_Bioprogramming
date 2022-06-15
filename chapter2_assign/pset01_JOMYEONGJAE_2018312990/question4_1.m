function diff_v = question4_1(v)
    len_v = length(v);
    diff_v(1:len_v-1) = v(2:len_v) - v(1:len_v-1);
    
    diff_v

end