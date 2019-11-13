%> RunLater is essentially a renamed wrapper around BuildLater,
%> intended for actions that do not necessarily involve 'build'ing.
%>
%> Note that runlaterclass and buildlaterclass names must not conflict
%>
%> runfcn will be called as runfcn(M,rlobj)
function rlobj=RunLater(M,tag,runlaterclasses,runfcn)

rlobj=BuildLater(M,tag,runlaterclasses,runfcn);

