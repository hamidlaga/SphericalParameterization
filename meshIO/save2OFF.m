function save2OFF(shape, fname)
fp = fopen(fname, 'w');

fprintf(fp, 'OFF\n');
[dim nVert] = size(shape.V);
[dim nFaces] = size(shape.Tri);


fprintf(fp, '%d %d 0\n', nVert, nFaces);

for (i=1:nVert)
   fprintf(fp, '%f %f %f\n',  shape.V(1, i), shape.V(2, i), shape.V(3, i));
end

if ~isfield(shape, 'segIdx') || isempty(shape.segIdx),
    for (i=1:nFaces)
       fprintf(fp, '3 %d %d %d\n',  shape.Tri(1, i)-1, shape.Tri(2, i)-1, shape.Tri(3, i)-1);
    end
else
    for (i=1:nFaces)
       fprintf(fp, '3 %d %d %d %d\n',  shape.Tri(1, i)-1, shape.Tri(2, i)-1, shape.Tri(3, i)-1, shape.segIdx(i)-1);
    end
end
fclose(fp);