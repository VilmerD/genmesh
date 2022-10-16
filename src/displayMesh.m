function displayMesh(enod, dof, edof, coord, boundary_nodes, bc, F, ...
    natural_nodes, robin_nodes, I_img, J_img)
% DISPLAYMESH displays the mesh, boundary conditions, loads etc
fig = figure;
t = tiledlayout(fig, 2, 1);

ax_essential = nexttile(t, 1, [1, 1]);
hold(ax_essential, 'on');

ax_natural = nexttile(t, 2, [1, 1]);
hold(ax_natural, 'on');

cx = coord(:, 1);
cy = coord(:, 2);


% Mesh grid
ex = cx(enod(:, 2:end));
ey = cy(enod(:, 2:end));
exext = [ex ex(:, 1)];
eyext = [ey ey(:, 1)];
meshlines_ess = plot(ax_essential, exext', eyext', 'k--');
meshlines_nat = plot(ax_natural, exext', eyext', 'k--');

% Boundary conditions
bcnodes = dof_to_node(bc(:, 1), dof);
boundary_lines = [];
boundary_labels = {};

bcxnodes = bcnodes(bcnodes(:, 2) == 1, 1);
bcx_line = plot(ax_essential, cx(bcxnodes), cy(bcxnodes), 'bx');
if ~isempty(bcx_line)
    boundary_lines(end+1) = bcx_line;
    boundary_labels{end+1} = 'Bcx';
end

bcynodes = bcnodes(bcnodes(:, 2) == 2, 1);
bcy_line = plot(ax_essential, cx(bcynodes), cy(bcynodes), 'bs');
if ~isempty(bcy_line)
    boundary_lines(end+1) = bcy_line;
    boundary_labels{end+1} = 'Bcy';
end

% Force
fnodes = dof_to_node(F(:, 1), dof);
force_lines = [];
force_labels = {};

fxnodes = fnodes(fnodes(:, 2) == 1, 1);
fx_line = plot(ax_essential, cx(fxnodes), cy(fxnodes), 'rx');
if ~isempty(fx_line)
    force_lines(end+1) = fx_line;
    force_labels{end+1} = 'Fx';
end

fynodes = fnodes(fnodes(:, 2) == 2, 1);
fy_line = plot(ax_essential, cx(fynodes), cy(fynodes), 'rs');
if ~isempty(fy_line)
    force_lines(end+1) = fy_line;
    force_labels{end+1} = 'Fy';
end

% Bounary nodes
bnodes_line = plot(ax_natural, cx(boundary_nodes), cy(boundary_nodes), 'b.');

% Homogenous neumann nodes
nnodes_line = plot(ax_natural, cx(natural_nodes), cy(natural_nodes), 'go');

% Robin nodes
rnodes_line = plot(ax_natural, cx(robin_nodes), cy(robin_nodes), 'ro');

% Legends
lines_ess = [meshlines_ess(1), boundary_lines, force_lines];
names_ess = [{'Mesh'}, boundary_labels, force_labels];
legend(ax_essential, ...
    lines_ess, names_ess, ...
    'Location', 'SouthOutside');

lines_nat = [meshlines_nat(1), bnodes_line, nnodes_line, rnodes_line];
names_nat = {'Mesh', 'Bounary nodes', 'Neumann BC (Hom)', 'Robin BC (Hom)'};
legend(ax_natural, ...
    lines_nat, names_nat, ...
    'Location', 'SouthOutside');

end

function nodes = dof_to_node(dofs, dof)
nodes = [];
for k = 1:numel(dofs)
    [dofk, dimk] = find(dof == dofs(k));
    nodes = [nodes; dofk dimk];
end
end