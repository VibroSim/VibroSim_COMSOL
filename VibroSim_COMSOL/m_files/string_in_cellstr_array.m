function res=string_in_cellstr_array(strng,cellstrarray)

res=false;

for cnt=1:length(cellstrarray)
  if strcmp(strng,cellstrarray{cnt})
    res=true;
  end
end