require 'pl'

describe('Set', function()
  local Set
  local set1

  setup(function()
    Set = require 'broom.set'
  end)

  before_each(function()
    set1 = Set {"hello", false, 5}
  end)

  it('#add', function()
    assert.is_false(set1:contains(nil))
    assert.is_false(set1:add(nil))
    assert.is_false(set1:contains(nil))

    assert.is_true(set1:contains(5))
    assert.is_false(set1:add(5))
    assert.is_true(set1:contains(5))

    assert.is_false(set1:contains(6))
    assert.is_true(set1:add(6))
    assert.is_true(set1:contains(6))
    assert.is_false(set1:add(6))
  end)

  it('#clear', function()
    assert.is_false(set1:is_empty())
    set1:clear()
    assert.is_true(set1:is_empty())
    assert.is_true(set1:add('fizz'))
    assert.is_false(set1:is_empty())
    set1:clear()
    assert.is_true(set1:is_empty())
  end)

  it('#contains', function()
    assert.is_true(set1:contains("hello"))
    assert.is_true(set1:contains(false))
    assert.is_true(set1:contains(5))
    assert.is_false(set1:contains(nil))
    assert.is_false(set1:contains(true))
    assert.is_false(set1:contains("stuff"))
  end)

  it('#is_empty', function()
    assert.is.equals(3, set1:size())
    assert.is_false(set1:is_empty())
    local emptySet = Set()
    assert.is.equals(0, emptySet:size())
    assert.is_true(emptySet:is_empty())
  end)

  it('#remove', function()
    assert.is_true(set1:contains("hello"))
    assert.is_true(set1:remove("hello"))
    assert.is_false(set1:contains("hello"))

    assert.is_false(set1:contains("stuff"))
    assert.is_false(set1:remove("stuff"))
    assert.is_true(set1:add("stuff"))
    assert.is_true(set1:contains("stuff"))
    assert.is_true(set1:remove("stuff"))
    assert.is_false(set1:contains("stuff"))
    assert.is_false(set1:remove("stuff"))
  end)

  it('#size', function()
    assert.are.equal(3, set1:size())
    assert.is_true(set1:remove('hello'))
    assert.are.equal(2, set1:size())
    local empty = Set.new()
    assert.are.equal(0, empty:size())
  end)

  it('#tostring', function()
    local s = tostring(set1)
    assert.is.not_nil(string.match(s, 'Set'))
    assert.is.not_nil(string.match(s, 'hello'))
    assert.is_nil(string.match(s, 'true'))
  end)

end)
