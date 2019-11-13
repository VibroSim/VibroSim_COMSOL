%> @breif CreateExcitationWindow Creates The Excitation Window
%>
%> This function defines a rectangular window with smooth edges to mark the beginning and end of excitation
%> Smoothing is performed as raised cosine window defined according to the excitation string.
%> GEN:BURST ARB <excfreq> Hz <t0> s <t1> s <t2> s <t3> s
%> where excfreq is the excitation frequency, t0 is the start of excitation, t1 is the point at which maximum ampitude is reached,
%> t2 is the point at which excitation starts to ramp down and t2 is when excitation stops.

function [excitationwindow] = CreateExcitationWindow(M,excitationwindowtag,t0,t1,t2,t3)

  excitation_rise_str = sprintf('0.5-0.5*cos(pi*(t-(%s))/((%s)-(%s)))', to_string(t0),to_string(t1),to_string(t0));
  excitation_fall_str = sprintf('0.5+0.5*cos(pi*(t-(%s))/((%s)-(%s)))', to_string(t2),to_string(t3),to_string(t2));

  excitationwindow = CreateFunction(M,excitationwindowtag,'Piecewise');
  excitationwindow.node.label(excitationwindowtag);

  % parameter: time
  excitationwindow.node.set('arg', 't');


  % set extrapolation
  excitationwindow.node.set('extrap', 'value');
  excitationwindow.node.set('extrapvalue', '0.0');

  
  excitationwindow.node.set('funcname', excitationwindowtag);
  excitationwindow.node.setIndex('pieces', t0, 0, 0);
  excitationwindow.node.setIndex('pieces', t1, 0, 1);
  excitationwindow.node.setIndex('pieces', excitation_rise_str, 0, 2);
  excitationwindow.node.setIndex('pieces', t1, 1, 0);
  excitationwindow.node.setIndex('pieces', t2, 1, 1);
  excitationwindow.node.setIndex('pieces', '1.0', 1, 2);
  excitationwindow.node.setIndex('pieces', t2, 2, 0);
  excitationwindow.node.setIndex('pieces', t3, 2, 1);
  excitationwindow.node.setIndex('pieces', excitation_fall_str, 2, 2);

  % function units
  excitationwindow.node.set('fununit', '1');

  % parameter units
  excitationwindow.node.set('argunit', 's');

end
