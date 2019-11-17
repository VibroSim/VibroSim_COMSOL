function abspath = buildabspath(relpath)
% Convert relpath into an absolute path

currentdir = pwd;
sep = filesep;

if sep == '\'
   % Windows
   colons = strfind(relpath,':');
   if length(colons) < 1
     % no drive letter
     if relpath(1) == sep
       % Leading backslash
       % ... add drive letter
       letterlength = strfind(currentdir,':')
       abspath = [ currentdir(1:letterlength) relpath ];
     else
       % fully relative
       abspath=fullfile(currentdir,relpath);
     end
   else
     % have drive letter. Fully absolute
     abspath = relpath;
   end
else
  % non-Windows
  if relpath(1)==sep
    % leading slash; fully absolute
    abspath = relpath
  else
    abspath=fullfile(currentdir,relpath);
  end
end
