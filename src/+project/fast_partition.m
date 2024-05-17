function P = fast_partition(oa,ob,bbx)
% project.fast_partition The function to compute the partition of the space from the convex-lifting function [<a href="matlab:web('https://breakmit-0.github.io/project-ppl/')">online docs</a>]
    %
    %
    % Usage : 
    %    P = fast_partition(oa,ob,bbx)
    %
    % Parameters :
    %    [oa,ob] are the values returned by lift.find
    %    oa is a matrix of dimension N x D while ob is an array of N scalars
    %    bbx is the value returned by util.bounding_box 
    %
    % Return Values :  
    %    P is an array of N polyhedra which represents the partition of the space
    %
    % See also project
    
    [N, D] = size(oa);
    P = repmat(Polyhedron(), N, 1);
    for i=1:N
        Ai = zeros([N, D]);
        bi = zeros([N,1]);
        for j=1:N
            Ai(j,:) = (oa(j,:) - oa(i,:))';
            bi(j) = ob(i) - ob(j);
        end
        Q = Polyhedron('A',Ai,'b',bi);
        P(i) = Q.intersect(bbx);
    end
end
