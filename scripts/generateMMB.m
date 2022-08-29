%% Make mesh
dimensions = [6000e-3 1000e-3];
q = dimensions(1)/dimensions(2);
yresolutions = [10 20 30 40 50 75];
xresolutions = ceil(yresolutions*q);
resolutions = [xresolutions; yresolutions];
for i = 1:numel(versions)
    for k = 1:size(resolutions, 2)
        generateMesh(resolutions(:, k), dimensions)
    end
end


function generateMesh(resolution, dimensions)
w = dimensions(1);
h = dimensions(2);

F = StructureFactory(resolution, dimensions);
ytol_left = 1e-6;
ytol_right = 1e-6;
bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*(abs(y - 0) < ytol_left));
bc2 = @(x, y) logical((abs(x - w) < 1e-6).*(abs(y - 0) < ytol_right));
F.addBoundaryCondition(bc2, [1, 2], 0);
F.addBoundaryCondition(bc1, [1, 2], 0);

% Prescribed force
fpos = @(x, y) logical((abs(x - w/2) < 1e-6).*(abs(y - h) < 1e-6));
F.addPrescribedForce(fpos, 2, -1);

format = sprintf('beamFull%ix%i.mat', resolution(:));
geomfile = ['Data/Meshes/DuOlhoff/', format];
F.make(4, geomfile);
end