local Set = require('broom.set')

local cfg = {
  Affirmative = Set{'Y', 'y'},
  Valid = Set{'Y', 'y', 'N', 'n'}
}

local Prompt = {}

function Prompt.prompt(q)
  io.write(q)
  io.flush()
  return io.read()
end

function Prompt.requires(q, a)
  local answer
  repeat
    answer = Prompt.prompt(q)
  until a:contains(answer)
  return answer
end

function Prompt.affirmative(q)
  return cfg.Affirmative:contains(Prompt.requires(q, cfg.Valid))
end

return Prompt
