function i = index_of(matrix, vector)
    for i = 1:(height(matrix))
        if norm(matrix(i, :) - vector) <= 0.001
            return
        end
    end

    i = -1;
end

