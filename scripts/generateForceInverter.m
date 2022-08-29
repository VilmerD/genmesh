%%
dimensions = [1000e-3 500e-3];
q = dimensions(1)/dimensions(2);
yresolutions = [100];
xresolutions = yresolutions*q;
resolutions = [xresolutions; yresolutions];
for k = 1:size(resolutions, 2)
    generateMesh(resolutions(:, k), dimensions);
end
    
function generateMesh(resolution, dimensions)
w = dimensions(1);
h = dimensions(2);

factory = StructureFactory(resolution, dimensions);
% Top border (symmetry)
bctop = @(x, y) logical(y == h);
factory.addBoundaryCondition(bctop, [2], 0);

% Lower left corner
bcheight = w*0.01;
bcbot = @(x, y) logical((x == 0).*(y <= bcheight));
factory.addBoundaryCondition(bcbot, [1, 2], 0);

% Prescribed force
ff = @(x, y) logical((y == h).*(x == 0));
factory.addPrescribedForce(ff, [1], 1);

% Save
filename = sprintf('%ix%i.mat', resolution(:));
geomfile = fullfile('Data/Meshes/Inverter', filename);
factory.make(4, geomfile);
end