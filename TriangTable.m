function data = TriangTable(v)

matrix = hankel(v);
data = cell(size(matrix,1), length(v));

for i = 1:size(matrix,1)
    row = matrix(i, :);
    newrow = row(row ~= 0);
    data(i, 1:length(newrow)) = mat2cell(newrow, [1], ones(1,size(newrow,2)));
end 

end