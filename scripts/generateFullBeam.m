%% Make mesh
dimensions = [8000e-3 1000e-3];
q = dimensions(1)/dimensions(2);
yresolutions = [10 20 30 40 50 75];
xresolutions = ceil(yresolutions*q);
resolutions = [xresolutions; yresolutions];
versions = {'a'};
folder = 'Projects/CAEigen/processed_data/meshes/do/8x1/';
for i = 1:numel(versions)
    for k = 1:size(resolutions, 2)
        generateMesh(folder, resolutions(:, k), dimensions, versions{i})
    end
end


function generateMesh(folder, res, dim, beam_case)
w = dim(1);
h = dim(2);

F = StructureFactory(res, dim);
switch beam_case
    case 'a'
        ytol_left = 1e-6;
        ytol_right = 1e-6;
        bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*(abs(y - h/2) < ytol_left));
        bc2 = @(x, y) logical((abs(x - w) < 1e-6).*(abs(y - h/2) < ytol_right));
        F.addBoundaryCondition(bc2, [1, 2], 0);
        F.addBoundaryCondition(bc1, [1, 2], 0);
    case 'b'
        ytol_left = h;
        ytol_right = 1e-6;
        bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*(abs(y - h/2) < ytol_left));
        bc2 = @(x, y) logical((abs(x - w) < 1e-6).*(abs(y - h/2) < ytol_right));
        F.addBoundaryCondition(bc2, [1, 2], 0);
        F.addBoundaryCondition(bc1, [1, 2], 0);
    case 'c'
        ytol_left = h;
        ytol_right = h;
        bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*(abs(y - h/2) < ytol_left));
        bc2 = @(x, y) logical((abs(x - w) < 1e-6).*(abs(y - h/2) < ytol_right));
        F.addBoundaryCondition(bc2, [1, 2], 0);
        F.addBoundaryCondition(bc1, [1, 2], 0);
    case 'd'
        ytol_left = 1e-6;
        ytol_right = 1e-6;
        bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*...
            (abs((y - h/2) - h/2) < ytol_left));
        bc2 = @(x, y) logical((abs(x - w) < 1e-6).*...
            (abs((y - h/2) - h/2) < ytol_right));
        F.addBoundaryCondition(bc2, [1, 2], 0);
        F.addBoundaryCondition(bc1, [1, 2], 0);
        
    otherwise
        errorStruct.message = sprintf('Invalid case: "%s"', beam_case);
        error(errorStruct);
end

% Prescribed force
fpos = @(x, y) logical((abs(x - w/2) < 1e-6).*(abs(y - h) < 1e-6));
F.addPrescribedForce(fpos, 2, -1);

file = sprintf('beamFull%s%ix%i.mat', beam_case, res(:));
geomfile = fullfile(folder, file);
F.make(4, geomfile);
end