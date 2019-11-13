function [matching,notmatching]=FilterMatching(inputvec,filterfcn)

matching=[];
notmatching=[];

for cnt=1:length(inputvec)
  if filterfcn(inputvec(cnt))
    matching(length(matching)+1)=inputvec(cnt);
  else
    notmatching(length(notmatching)+1)=inputvec(cnt);
  end
end
	   