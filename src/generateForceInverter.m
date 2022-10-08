function generateForceInverter(file, res, dim)
w = dim(1);
h = dim(2);

factory = StructureFactory(res, dim);

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
factory.make(4, file);
end