function test_2d(n_obs, spacing)
arguments
    n_obs = 10;
    spacing = 30;
end
    p = Generation_obstacles(2, n_obs, 1, 0.2, 0.1, spacing);
    [oa, ob] = find_lift(p);
    check_constraints(p, oa, ob);
    plot_2d(p, oa, ob, spacing);
end
