function  plot(g)
    pos = g.Nodes.position;
    if size(pos, 2) == 2
        plot(g, 'XData', pos(:,1), 'YData', pos(:,2));
    else 
        plot(g, 'XData', pos(:,1), 'YData', pos(:,2), 'ZData', pos(:,3));
    end
end

