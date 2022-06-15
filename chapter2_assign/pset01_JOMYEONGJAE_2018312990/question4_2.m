function diff_A = question4_2(A)
    len_col = length(A(1, :)); %열의 길이
    len_row = length(A(:, 1)); %행의 길이
    diff_A = A([1:len_row-1], [1:len_col]) - A([2:len_row], [1:len_col]);
    
    diff_A

end