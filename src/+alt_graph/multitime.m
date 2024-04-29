function result = mutitime(destfile)

    range = 5:5:100;
    N = size(range, 2);
    result = [];


    j = 0;
    for i = range
        result = [result; [i alt_graph.timeit(i, 100, 2)]];
        j = j + 1;
        fprintf("\rrunning timings (%d/%d)", j, N);
    end
    fprintf("\n");


    if exist("destfile", "var")
        writematrix(result, destfile, "Encoding", "UTF-8", "Delimiter", ',')
        fprintf("wrote data to %s\n", destfile);
    end



    curves = plot(result(:, 1), result(:, 2:end), "LineWidth", 2);

    legend(curves, ["gen", "lift", "project", "edges", "graph", "path"], "Location", "westoutside")
end
