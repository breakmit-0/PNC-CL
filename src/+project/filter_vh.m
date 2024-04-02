function pass = filter_vh(faces) 
    pass = [];
    
    N = size(faces);
    for i = 1:N
        normal = faces(i).He(1,1:end-1);
        ok = ~util.is_near_unit(normal);
        if ok
            pass = [pass; faces(i)];
        end
    end
end
