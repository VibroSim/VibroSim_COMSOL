%> function ca_vec=to_cellstr_array(vec,units)
%> Convert provided vector, which may be a cell string array already,
%> a numeric vector, etc. into a cell array of strings.
%> Units is an optional parameter that gets added inside [] to each component
%> if vec is numeric
function ca_vec=to_cellstr_array(vec,units)

%global fubar
%fubar=vec

ca_vec={};

if strcmp(class(vec),'java.lang.String[]')
  for cnt=1:numel(vec)
    ca_vec{cnt}=char(vec(cnt));
  end
elseif strcmp(class(vec),'java.lang.String')
  ca_vec{1}=char(vec);
else 
  for cnt=1:numel(vec)
    if isa(vec(cnt),'double')
      if exist('units','var')
        ca_vec{cnt}=[ num2str(vec(cnt),18) '[' units ']' ];
      else
        ca_vec{cnt}=num2str(vec(cnt),18);   
      end
    elseif isa(vec,'cell') &&isa(vec{cnt},'double')
      if exist('units','var')
        ca_vec{cnt}=[ num2str(vec{cnt},18) '[' units ']' ];
      else
        ca_vec{cnt}=num2str(vec{cnt},18);   
      end
    else
      ca_vec(cnt)=vec(cnt);
    end
  end
end   
