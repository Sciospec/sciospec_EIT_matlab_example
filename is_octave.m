function tf = is_octave()
  tf = (exist('OCTAVE_VERSION', 'builtin') ~= 0);
end