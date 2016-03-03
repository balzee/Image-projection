
function [Ai] = generate2rows(world_coord, image_coord)

zeros4 = zeros(4, 1);
u = image_coord(1);
v = image_coord(2);
Xi = [world_coord; 1];
Ai = [   Xi', zeros4', -u * Xi'; 
        zeros4', Xi', -v * Xi'; ];