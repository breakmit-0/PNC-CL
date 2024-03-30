homothetie_factor = 0.9;

pointA = [-1 -0.75; 0.1 0.75; 0 2] + 2;
pointB = [-1 -0.75; -0.5 -0.25; 1 -0.75] + 2;
pointC = [1 -0.75; 0.5 -0.35; 0 2] + 2;
pointD = [-0.5 -0.25; 0.1 0.75; 0.5 -0.35] + 2;
pointE = [-1 -0.75; -0.5 -0.25; 0.1 0.75] + 2;
pointF = [0.5 -0.35; 0.1 0.75; 0 2] + 2;
pointG = [-0.5 -0.25; 0.5 -0.35; 1 -0.75] + 2;

A = Polyhedron(pointA);
B = Polyhedron(pointB);
C = Polyhedron(pointC);
D = Polyhedron(pointD);
E = Polyhedron(pointE);
F = Polyhedron(pointF);
G = Polyhedron(pointG);

A1 = reduction(A,homothetie_factor);
B1 = reduction(B,homothetie_factor);
C1 = reduction(C,homothetie_factor);
D1 = reduction(D,homothetie_factor);
E1 = reduction(E,homothetie_factor);
F1 = reduction(F,homothetie_factor);
G1 = reduction(G,homothetie_factor);


P = [A;B;C;D;E;F;G];
P1 = [A1;B1;C1;D1;E1;F1;G1];

% plot(P)
% hold on
% plot(P1)

[oa, ob] = find_lift(P1);
check_constraints(P1, oa, ob);
plot_2d(P1, oa, ob, 5);