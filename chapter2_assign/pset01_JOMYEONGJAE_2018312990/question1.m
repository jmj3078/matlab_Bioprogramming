function percentage_five = question1(dice)
    num_five = length(find(dice == 5));
    num_total = length(dice);
    percentage_five = num_five / num_total;
end