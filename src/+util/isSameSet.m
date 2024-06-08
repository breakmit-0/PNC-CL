function ts = isSameSet(P1,P2)
    ts = 0;

    if ~P1.hasVRep
        P1.computeVRep;
    end

    if ~P2.hasVRep
        P2.computeVRep;
    end

    counter = 0;
    for i = 1:size(P1.V,1)
        if ismembertol(P1.V(i,:),P2.V,1e-4,'ByRows',true)
            counter = counter + 1;
        else
            return
        end
    end
    if counter == i
        ts = 1;
        return
    end

end