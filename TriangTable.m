function data = TriangTable(metpath)

load([metpath filesep 'pairwise_corr_result.mat']);
tri = tril(corr_result.pearson_Rs);

data = cell(size(tri));

for i = 1:size(tri, 1)
    row = tri(i, :);
    ind = find(row == 1);
    newrow = row(1:ind(end) - 1);
    data(i, 1:length(newrow)) = mat2cell(newrow, [1], ones(1,size(newrow,2)));
end 

end