function save2OBJ(shape, fname)


fp = fopen(fname, 'w');



[dim nVert] = size(shape.V);
[dim nFaces] = size(shape.Tri);




for i=1:nVert
   fprintf(fp, 'v %f %f %f\n',  shape.V(1, i), shape.V(2, i), shape.V(3, i));
end


for (i=1:nFaces)
   fprintf(fp, 'f %d %d %d\n',  shape.Tri(1, i), shape.Tri(2, i), shape.Tri(3, i));
end

fclose(fp);