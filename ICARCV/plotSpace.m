function fobj = plotSpace(Y, P, G, PI, trajectory)


    dim = Y(1).Dim;
    pos = G.Nodes.position;

    fobj = figure();
    hold on


    if dim == 2
        if ~isempty(Y)
            Y.plot('color', 'lightblue','alpha',0.6)
        end
        if ~isempty(G)
            plot(G, 'XData', pos(:,1), 'YData', pos(:,2));
        end
        if ~isempty(P)
            P.plot('color', 'r','alpha',0.3)
        end
        if ~isempty(PI)
            plot(PI,'alpha',0.6,'color',[1 1 0],'edgealpha',0.5)
        end
        if ~isempty(trajectory)
            plot(trajectory(:,1),trajectory(:,2),'Marker','*','LineStyle','-','color',[0 0 0],'LineWidth',1.5);
        end
        
        
        

    else 

        if ~isempty(Y)
            Y.plot('color', 'lightblue','alpha',0.2)
        end
        if ~isempty(G)
            plot(G, 'XData', pos(:,1), 'YData', pos(:,2), 'ZData', pos(:,3));
        end
        if ~isempty(P)
            P.plot('color', 'r','alpha',0.3)
        end
        if ~isempty(PI)
            plot(PI,'alpha',0.3,'color',[1 1 0],'edgealpha',0.0)
        end
        if ~isempty(trajectory)
            plot3(trajectory(:,1),trajectory(:,2),trajectory(:,3),'Marker','*','LineStyle','-','color',[0 0 0],'LineWidth',1.5);
        end
        

    end
    hold off

end