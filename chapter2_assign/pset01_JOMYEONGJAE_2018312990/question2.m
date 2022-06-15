function matrix = question2(matrix)
    num_row = length(matrix(:, 1)); %주어진 행렬 열의 길이 = 행의 개수
    num_row_vec = (1:num_row); %행의 숫자를 나타내는 벡터
    matrix = [matrix, num_row_vec']; %벡터를 transpose하여 열방향으로 추가
    
    matrix
    
    %Question2-2) 
    %circshift함수 사용 : matrix = circshift(matrix, 1, 2)
    
    num_col = length(matrix(1, :)); %주어진 행렬 행의 길이 = 열의 개수
    matrix(:, [2:num_col]) = matrix(:, [1:num_col-1]); %한칸씩 오른쪽으로 밀어내기
    matrix(:, 1) = num_row_vec'; %첫번째 열에 행 숫자를 나타내는 벡터를 transpose하여 대치
    
    matrix
end