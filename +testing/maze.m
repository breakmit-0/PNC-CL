function walls = maze()

    N = 6;
    ints = int_maze(N);
    %
    % chars = [
    %     "   " " ╨ " "  ═" " ╚═" ...
    %     " ╥ " " ║ " " ╔═" " ╠═" ...
    %     "═  " "═╝ " "═══" "═╩═" ...
    %     "═╗ " "═╣ " "═╦═" "═╬═"
    % ];
    % for j = 1:N
    %     for i = 1:N
    %         fprintf("%s", chars(polys(i,j)+1));
    %     end
    %     fprintf("\n");
    % end
    walls = [];    
    for j = 1:N
        for i = 1:N
            if ~bitand(ints(i,j), 2)
                walls = [walls; Polyhedron([
                        [i+0.9 j];
                        [i+0.9 j+1];
                        [i+1.1 j];
                        [i+1.1 j+1];
                    ])];
            end
            if  ~bitand(ints(i,j), 4)
                walls = [walls; Polyhedron([
                    [i j+0.9];
                    [i+1 j+0.9];
                    [i j+1.1];
                    [i+1 j+1.1];
                ])];
            end
        end
    end

    walls = arrayfun(@(p) util.reduction(p, 0.8), walls);
    plot(walls);

end



function out = int_maze(N)

    out = zeros(N, N, "uint8");
    done = zeros(N, N, "logical");
    stack = java.util.Stack();
    stack.push([1 1]);

    out(1,1) = 1;
    out(N,N) = 4;

    deltas = [
        [0 -1];
        [1 0];
        [0 1];
        [-1 0]
    ];

    while ~stack.empty()
        ij = stack.pop();
        i = ij(1);
        j = ij(2);
        done(i, j) = true;

        if out(i,j) < 15 
            
            first_dir = randi([0 3], 1, 1);

            for extra = 1:4
                next_dir = mod(first_dir + extra, 4);                
                k = i + deltas(next_dir+1, 1);
                l = j + deltas(next_dir+1, 2);
               
                if k <= 0 || l <= 0 || k > N || l > N
                    continue;
                end

                if done(k,l)
                    continue;
                end
               
                % found a target
                bitwise_ij = bitsll(1, next_dir);
                bitwise_kl = bitsll(1, mod(next_dir+2, 4));
                out(i,j) = bitor(out(i,j), bitwise_ij);
                out(k,l) = bitor(out(k,l), bitwise_kl);
                
                if out(i,j) < 15
                    stack.push([i j]);
                end
                stack.push([k l]);
                break;
            end
            
            % if no success, just let it backtrack
        end
    end
end


